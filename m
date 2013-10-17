Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab3JQQ7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:59:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994Ab3JQQ7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:59:39 -0400
Message-ID: <1382029114.1768.10.camel@deneb.redhat.com>
Subject: Re: [PATCH v2 2/3] arm: Add [U]EFI runtime services support
From: Mark Salter <msalter@redhat.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Matt Fleming <matt@console-pimps.org>,
        linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, matt.fleming@intel.com,
        grant.likely@secretlab.ca, roy.franz@linaro.org
Date: Thu, 17 Oct 2013 12:58:34 -0400
In-Reply-To: <20131017143121.GJ1557@rocoto.smurfnet.nu>
References: <1380799481-5470-1-git-send-email-leif.lindholm@linaro.org>
	 <1380799481-5470-3-git-send-email-leif.lindholm@linaro.org>
	 <20131017140739.GI10834@console-pimps.org>
	 <20131017143121.GJ1557@rocoto.smurfnet.nu>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-17 at 16:31 +0200, Leif Lindholm wrote:
> On Thu, Oct 17, 2013 at 03:07:39PM +0100, Matt Fleming wrote:
> > > +/*
> > > + * If you need to (temporarily) support buggy firmware.
> > > + */
> > > +#define KEEP_BOOT_SERVICES_REGIONS
> > 
> > Have you seen firmware that requires this? I'm just curious more than
> > anything else.
> 
> Not really.
> I _think_ I saw it on a debug build of a development platform once.
> That coincided with me seeing a post on linux-efi about some laptop
> that broke unless boot services regions were preserved, so I decided
> to put it in there for any future debugging.
>  

I see a fairly consistent segfault when the arm64 kernel calls the
SetVirtualAddressMap function. It doesn't happen when the boot services
regions are included in the mapping. This is with edk2 firmware. I
haven't really dug into where it goes wrong.


