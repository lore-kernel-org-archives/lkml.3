Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab3GESVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 14:21:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56557 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757402Ab3GESVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 14:21:14 -0400
Date: Fri, 5 Jul 2013 20:21:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Stefan Sabolowitsch <Stefan.Sabolowitsch@felten-group.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Subject: Re: get a kernel crash with kernel 3.10.0-1.el6.elrepo.x86_64
Message-ID: <20130705182106.GA29025@pd.tnic>
References: <CDFC5EEC.A5BF%Stefan.Sabolowitsch@felten-group.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CDFC5EEC.A5BF%Stefan.Sabolowitsch@felten-group.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 09:30:53AM +0000, Stefan Sabolowitsch wrote:
> Hi all,
> I get a kernel crash with 3.10.0-1.el6.elrepo.x86_64 (on two machines the
> same problem).
> Never seen on v3.8.x / v3.9x
> 
> Any idea ?
> 
> Thx
> Stefan
> 
> -#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-
> 
> abrt_version:   2.0.8
> cmdline:        ro root=/dev/mapper/vg_ipd2-lv_root rd_NO_LUKS rd_NO_MD
> SYSFONT=latarcyrheb-sun16 crashkernel=auto rd_LVM_LV=vg_ipd2/lv_swap
> rd_NO_DM LANG=de_DE.UTF-8  KEYBOARDTYPE=pc KEYTABLE=de
> rd_LVM_LV=vg_ipd2/lv_root rhgb quiet
> kernel:         3.10.0-1.el6.elrepo.x86_64
> time:           Do 04 Jul 2013 16:18:29 GMT
> 
> sosreport.tar.xz: Binary file, 1665652 bytes
> 
> backtrace:
> :WARNING: at drivers/dma/ioat/dca.c:697 ioat3_dca_init+0x1f2/0x200
> [ioatdma]()
> :ioatdma 0000:00:16.0: APICID_TAG_MAP set incorrectly by BIOS, disabling
> DCA

It basically says that your BIOS is b0rked
(f3c78f8515dd4cb9e26040ebb54cf589d21137ee) and disables the Direct Cache
Access.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
