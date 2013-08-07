Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab3HGQqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:46:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:30521 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757260Ab3HGQp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:45:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,834,1367996400"; 
   d="scan'208";a="377587238"
Date: Wed, 7 Aug 2013 09:45:57 -0700
From: Jon Mason <jon.mason@intel.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Jaeger <christophjaeger@linux.com>, linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        tech.support@emulex.com, David Woodhouse <dwmw2@infradead.org>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH 1/1] module: fix sprintf format specifier in
 param_get_byte()
Message-ID: <20130807164557.GA9783@jonmason-lab>
References: <1375823532-24153-1-git-send-email-christophjaeger@linux.com>
 <87y58eov9u.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y58eov9u.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 04:13:57PM +0930, Rusty Russell wrote:
> Christoph Jaeger <christophjaeger@linux.com> writes:
> > In param_get_byte(), to which the macro STANDARD_PARAM_DEF(byte, ...) expands,
> > "%c" is used to print an unsigned char. So it gets printed as a character what
> > is not intended here. Use "%hhu" instead.
> >
> > Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
> 
> Nice patch.  Unfortunately, there are several users of this already:
> 
> drivers/net/wireless/cw1200/main.c:50:module_param_array_named(macaddr, cw1200_mac_template, byte, NULL, S_IRUGO);
> drivers/ntb/ntb_transport.c:68:module_param(max_num_clients, byte, 0644);

This shouldn't affect NTB negatively.

Acked-by: Jon Mason <jon.mason@intel.com>

> drivers/scsi/lpfc/lpfc_attr.c:4207:module_param(lpfc_prot_guard, byte, S_IRUGO);
> drivers/usb/atm/speedtch.c:117:module_param(ModemMode, byte, S_IRUGO | S_IWUSR);
> drivers/usb/atm/speedtch.c:121:module_param_array(ModemOption, byte, &num_ModemOption, S_IRUGO);
> drivers/usb/gadget/g_ffs.c:95:module_param_named(bDeviceClass,    gfs_dev_desc.bDeviceClass,    byte,   0644);
> drivers/usb/gadget/g_ffs.c:97:module_param_named(bDeviceSubClass, gfs_dev_desc.bDeviceSubClass, byte,   0644);
> drivers/usb/gadget/g_ffs.c:99:module_param_named(bDeviceProtocol, gfs_dev_desc.bDeviceProtocol, byte,   0644);
> 
> I have CC'd all the authors, to see if changing the results of reading
> /sys/module/<modname>/parameters/<xxx> from a literal char to a number
> will harm them.
> 
> Thanks,
> Rusty.
> 
> > ---
> >  kernel/params.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kernel/params.c b/kernel/params.c
> > index 440e65d..59f7ac7 100644
> > --- a/kernel/params.c
> > +++ b/kernel/params.c
> > @@ -252,7 +252,7 @@ int parse_args(const char *doing,
> >  	EXPORT_SYMBOL(param_ops_##name)
> >  
> >  
> > -STANDARD_PARAM_DEF(byte, unsigned char, "%c", unsigned long, strict_strtoul);
> > +STANDARD_PARAM_DEF(byte, unsigned char, "%hhu", unsigned long, strict_strtoul);
> >  STANDARD_PARAM_DEF(short, short, "%hi", long, strict_strtol);
> >  STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, strict_strtoul);
> >  STANDARD_PARAM_DEF(int, int, "%i", long, strict_strtol);
> > -- 
> > 1.8.3.1
