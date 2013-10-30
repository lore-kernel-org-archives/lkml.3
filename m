Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab3J3LRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:17:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:32913 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab3J3LRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:17:33 -0400
Date: Wed, 30 Oct 2013 12:17:25 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 21/21] scripts/gdb: Add basic documentation
Message-ID: <20131030111725.GA13298@pd.tnic>
References: <cover.1382950737.git.jan.kiszka@siemens.com>
 <09fd0723f610c8bb33465c8a909f4269a35cdcf4.1382950737.git.jan.kiszka@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <09fd0723f610c8bb33465c8a909f4269a35cdcf4.1382950737.git.jan.kiszka@siemens.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 09:58:58AM +0100, Jan Kiszka wrote:
> CC: Rob Landley <rob@landley.net>
> CC: linux-doc@vger.kernel.org
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>  Documentation/gdb-kernel-debugging.txt | 159 +++++++++++++++++++++++++++++++++
>  1 file changed, 159 insertions(+)
>  create mode 100644 Documentation/gdb-kernel-debugging.txt
> 
> diff --git a/Documentation/gdb-kernel-debugging.txt b/Documentation/gdb-kernel-debugging.txt
> new file mode 100644
> index 0000000..944f2d2
> --- /dev/null
> +++ b/Documentation/gdb-kernel-debugging.txt
> @@ -0,0 +1,159 @@
> +Debugging kernel and modules via gdb
> +====================================
> +
> +The kernel debugger kgdb, hypervisors like QEMU or JTAG-based hardware
> +interfaces allow to debug the Linux kernel and its modules during runtime
> +using gdb. Gdb comes with a powerful scripting interface for python. The
> +kernel provides a collection of helper scripts that can simplify typical
> +kernel debugging steps. This is a short tutorial about how to enable and use
> +them. It focuses on QEMU/KVM virtual machines as target, but the examples can
> +be transferred to the other gdb stubs as well.
> +
> +
> +Requirements
> +------------
> +
> + o gdb 7.2+ (recommended: 7.4+) with python support enabled (typically true
> +   for distributions)
> +
> +
> +Setup
> +-----
> +
> + o Create a virtual Linux machine for QEMU/KVM (see www.linux-kvm.org and
> +   www.qemu.org for more details). For cross-development,
> +   http://landley.net/aboriginal/bin keeps a pool of machine images and
> +   toolchains that can be helpful to start from.
> +
> + o Build the kernel with CONFIG_DEBUG_INFO and CONFIG_KALLSYMS enabled, but
> +   leave CONFIG_DEBUG_INFO_REDUCED off.
> +
> + o Install that kernel on the guest.
> +
> +   Alternatively, QEMU allows to boot the kernel directly using -kernel,
> +   -append, -initrd command line switches. This is generally only useful if
> +   you do not depend on modules. See QEMU documentation for more details on
> +   this mode.
> +
> + o Enable the gdb stub of QEMU/KVM, either
> +    - at VM startup time by appending "-s" to the QEMU command line
> +   or
> +    - during runtime by issuing "gdbserver" from the QEMU monitor
> +      console
> +
> + o cd /path/to/linux-build
> +
> + o Start gdb: gdb vmlinux
> +
> +   Note: Some distros may restrict auto-loading of gdb scripts to known safe
> +   directories. In case gdb reports to refuse loading vmlinux-gdb.py, add
> +
> +    add-add-auto-load-safe-path /path/to/linux-build

Only one "add-" should be enough :)

Btw, gdb is nice enough to tell me:

$ gdb vmlinux
Reading symbols from /w/kernel/linux-2.6/vmlinux...done.
warning: File "/w/kernel/linux-2.6/scripts/gdb/vmlinux-gdb.py" auto-loading has been declined by your `auto-load safe-path' set to "$debugdir:$datadir/auto-load".
To enable execution of this file add
        add-auto-load-safe-path /w/kernel/linux-2.6/scripts/gdb/vmlinux-gdb.py
line to your configuration file "/home/boris/.gdbinit".
To completely disable this security protection add
        set auto-load safe-path /
line to your configuration file "/home/boris/.gdbinit".
For more information about this security protection see the
"Auto-loading safe path" section in the GDB manual.  E.g., run from the shell:
        info "(gdb)Auto-loading safe path"

Other than that, that's a very cool stuff and I'll make sure to be using
it the next time.

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
