Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab3LPCIm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 21:08:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab3LPCIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 21:08:41 -0500
Date: Mon, 16 Dec 2013 10:00:10 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [PATCH v5 10/14] efi: only print saved efi runtime maps instead
 of all memmap ranges for kexec
Message-ID: <20131216020010.GC3754@dhcp-16-126.nay.redhat.com>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-11-git-send-email-dyoung@redhat.com>
 <20131213160150.GE32329@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213160150.GE32329@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -	print_efi_memmap();
> > +	if (efi_setup) {
> > +		int s;
> > +		struct efi_setup_data *data;
> > +
> > +		s = sizeof(*data) + nr_efi_runtime_map * sizeof(data->map[0]);
> > +		data = early_memremap(efi_setup, s);
> > +		if (!data)
> > +			return;
> > +		print_efi_memmap(data->map, nr_efi_runtime_map,
> > +				 sizeof(data->map[0]));
> > +		early_memunmap(data, s);
> 
> Well, if you call print_efi_memmap() in parse_efi_setup() you can save
> yourself that map/unmaping no?

In parse_efi_setup, I need map twice as well:
  mapping sizeof(struct setup_data) to get the payload len, then mapping
  the data->map again and call print_efi_memmap..

Another where what I print in this patch is same position what non-kexec kernel
does, it looks better that print them only if earlier init is ok. 

--
Thanks for review
Dave
