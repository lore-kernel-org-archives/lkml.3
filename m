Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbaIDMwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 08:52:36 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:45817 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaIDMwe convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Thu, 4 Sep 2014 08:52:34 -0400
Message-Id: <54087CAE0200007800030D79@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Thu, 04 Sep 2014 13:52:30 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Juergen Gross" <JGross@suse.com>
Cc: <david.vrabel@citrix.com>, <xen-devel@lists.xensource.com>,
        <boris.ostrovsky@oracle.com>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] xen: sync some headers with xen tree
References: <1409834326-29287-1-git-send-email-jgross@suse.com>
 <1409834326-29287-2-git-send-email-jgross@suse.com>
In-Reply-To: <1409834326-29287-2-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 04.09.14 at 14:38, <"jgross@suse.com".non-mime.internet> wrote:
> As the KEXEC and DUMPCORE related ELFNOTES are not relevant for the
> kernel they are omitted from elfnote.h.

But the defines are still in the patch:

> @@ -153,6 +192,65 @@
>   */
>  #define XEN_ELFNOTE_SUPPORTED_FEATURES 17
>  
> +/*
> + * The number of the highest elfnote defined.
> + */
> +#define XEN_ELFNOTE_MAX XEN_ELFNOTE_SUPPORTED_FEATURES
> +
> +/*
> + * System information exported through crash notes.
> + *
> + * The kexec / kdump code will create one XEN_ELFNOTE_CRASH_INFO
> + * note in case of a system crash. This note will contain various
> + * information about the system, see xen/include/xen/elfcore.h.
> + */
> +#define XEN_ELFNOTE_CRASH_INFO 0x1000001
> +
> +/*
> + * System registers exported through crash notes.
> + *
> + * The kexec / kdump code will create one XEN_ELFNOTE_CRASH_REGS
> + * note per cpu in case of a system crash. This note is architecture
> + * specific and will contain registers not saved in the "CORE" note.
> + * See xen/include/xen/elfcore.h for more information.
> + */
> +#define XEN_ELFNOTE_CRASH_REGS 0x1000002
> +
> +
> +/*
> + * xen dump-core none note.
> + * xm dump-core code will create one XEN_ELFNOTE_DUMPCORE_NONE
> + * in its dump file to indicate that the file is xen dump-core
> + * file. This note doesn't have any other information.
> + * See tools/libxc/xc_core.h for more information.
> + */
> +#define XEN_ELFNOTE_DUMPCORE_NONE               0x2000000
> +
> +/*
> + * xen dump-core header note.
> + * xm dump-core code will create one XEN_ELFNOTE_DUMPCORE_HEADER
> + * in its dump file.
> + * See tools/libxc/xc_core.h for more information.
> + */
> +#define XEN_ELFNOTE_DUMPCORE_HEADER             0x2000001
> +
> +/*
> + * xen dump-core xen version note.
> + * xm dump-core code will create one XEN_ELFNOTE_DUMPCORE_XEN_VERSION
> + * in its dump file. It contains the xen version obtained via the
> + * XENVER hypercall.
> + * See tools/libxc/xc_core.h for more information.
> + */
> +#define XEN_ELFNOTE_DUMPCORE_XEN_VERSION        0x2000002
> +
> +/*
> + * xen dump-core format version note.
> + * xm dump-core code will create one XEN_ELFNOTE_DUMPCORE_FORMAT_VERSION
> + * in its dump file. It contains a format version identifier.
> + * See tools/libxc/xc_core.h for more information.
> + */
> +#define XEN_ELFNOTE_DUMPCORE_FORMAT_VERSION     0x2000003
> +
>  #endif /* __XEN_PUBLIC_ELFNOTE_H__ */
>  
>  /*

Jan

