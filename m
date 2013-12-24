Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab3LXAxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 19:53:48 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:58377 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab3LXAxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 19:53:47 -0500
From: Derek Perrin <d.roc16@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: firmware: edd: fixed coding style errors
Date: Mon, 23 Dec 2013 18:53:46 -0600
Message-ID: <2057495.KkFWMBqotF@slave1>
User-Agent: KMail/4.12 (Linux/3.12.5-gentoo; KDE/4.12.0; x86_64; ; )
In-Reply-To: <1387750419.22671.25.camel@joe-AO722>
References: <1387747039-14098-1-git-send-email-d.roc16@gmail.com> <1387750419.22671.25.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 22, 2013 02:13:39 PM Joe Perches wrote:
> On Sun, 2013-12-22 at 15:17 -0600, Derek Perrin wrote:
> > Fixed coding style errors. Spaces, tab and parenthesis errors.
> 
> There's a real error in this patch.
> 
> When you do whitespace only changes, please
> verify that the old and new object files produced
> are unchanged.
> 
> One trivial bit too,
> 
> > diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
> 
> []
> 
> > @@ -62,8 +62,8 @@ struct edd_device {
> > 
> >  struct edd_attribute {
> >  
> >  	struct attribute attr;
> > 
> > -	ssize_t(*show) (struct edd_device * edev, char *buf);
> > -	int (*test) (struct edd_device * edev);
> > +	ssize_t(*show) (struct edd_device *edev, char *buf);
> > +	int (*test) (struct edd_device *edev);
> 
> I think most prefer function pointer prototypes like:
> 
> 	size_t (*show)(struct edd_device *edev, char *buf);
> 	int (*test)(struct edd_device *edev);
> 
> > @@ -791,7 +791,7 @@ edd_exit(void)
> > 
> >  	struct edd_device *edev;
> >  	
> >  	for (i = 0; i < edd_num_devices(); i++) {
> > 
> > -		if ((edev = edd_devices[i]))
> > +		if ((edev == edd_devices[i]))
> > 
> >  			edd_device_unregister(edev);
> >  	
> >  	}
> >  	kset_unregister(edd_kset);
> 
> This is wrong.
> It's an assignment in the block and it's important.
> 
> This could be rewritten as:
> 
> 	for (i = 0; i < edd_num_devices(); i++) {
> 		edev = edd_devices[i];
> 		if (edev)
> 			edd_device_unregister(edev);
> 	}
> 
> or just remove the temporary.


Sorry, I'm really new to contributing to the kernel and just learning the 
process. I can make a new patch that fixes the assignment. I'm not seeing any 
difference between what I did and what you said about the function pointer 
prototypes. 
