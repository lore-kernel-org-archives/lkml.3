Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaBXUjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 15:39:13 -0500
Received: from mout.gmx.net ([212.227.15.18]:54950 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbaBXUjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 15:39:10 -0500
Message-ID: <530BADE9.9020101@gmx.de>
Date: Mon, 24 Feb 2014 21:39:05 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
CC: kernel@gentoo.org, kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: 3.13 hangs when I tried to start a KVM at a 32 bit stable Gentoo
References: <52DEA270.60803@gmx.de> <52E165B7.6020506@intel.com>
In-Reply-To: <52E165B7.6020506@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:+2/QmplRc57ytUxs2SCZo/DUW2fH1/3Qbdr9A0Cd2TTJSMEh8mX
 RDrsQejmn8HTyPjgqhOdpbLbx4RPx0bNy/fM6xnTDAYeu4X8PnH1x/5snbP2nPxS421VdpW
 GT4bPo/LHh3vg3iINSbVcRFGl7nzZCgitBOhMDKqgpU1Uf8YXdXztxEKWEb3Qm3RJMMWyPw
 PE4sWT27RpVlsty4F5d3Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 01/23/2014 07:55 PM, Dave Hansen wrote:
> On 01/21/2014 08:38 AM, Toralf Förster wrote:
>> Jan 21 17:18:57 n22 kernel: INFO: rcu_sched self-detected stall on CPU { 2}  (t=60001 jiffies g=18494 c=18493 q=183951)
>> Jan 21 17:18:57 n22 kernel: sending NMI to all CPUs:
>> Jan 21 17:18:57 n22 kernel: NMI backtrace for cpu 2
>> Jan 21 17:18:57 n22 kernel: CPU: 2 PID: 6779 Comm: qemu-system-x86 Not tainted 3.13.0 #3
>> Jan 21 17:18:57 n22 kernel: Hardware name: LENOVO 4180F65/4180F65, BIOS 83ET75WW (1.45 ) 05/10/2013
>> Jan 21 17:18:57 n22 kernel: task: e921c370 ti: e5f36000 task.ti: e5f36000
> 
> I'm seeing a very similar hang with an ubuntu guest and a custom kernel.
>  I'm on commit 0dc3fd0249a, and it's 100% reproducible every time I run KVM.
> 
> Cc-ing a few more folks...
> 

I tried to bisect it - the first attempt to bisetc it between v3.12. and v3.13 blamed this commit :

commit 37bf06375c90a42fe07b9bebdb07bc316ae5a0ce
Merge: 6bfa687 d0e639c
Author: Ingo Molnar <mingo@kernel.org>
Date:   Wed Oct 9 12:36:13 2013 +0200

    Merge tag 'v3.12-rc4' into sched/core

    Merge Linux v3.12-rc4 to fix a conflict and also to refresh the tree
    before applying more scheduler patches.

    Conflicts:
        arch/avr32/include/asm/Kbuild

    Signed-off-by: Ingo Molnar <mingo@kernel.org>


which seems rather to be the upper limit where to search for the first bad commit, or ?



- -- 
MfG/Sincerely
Toralf Förster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlMLregACgkQxOrN3gB26U7P7gD/Wage68loQ++oP4moD94kTNpn
goyT7fvssm3jyF+2HagA/0EIR5MOcl7xlBPNw5JKqcI0pPx0yBytUljtz+KTPS/Y
=P8vB
-----END PGP SIGNATURE-----
