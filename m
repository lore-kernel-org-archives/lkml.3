Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761349Ab3ICVP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 17:15:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759990Ab3ICVP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 17:15:57 -0400
Date: Tue, 3 Sep 2013 17:15:44 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: yhchen@faraday-tech.com, gregkh@linuxfoundation.org
Subject: Re: usb: host: Faraday fotg210-hcd driver
Message-ID: <20130903211544.GB2247@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	yhchen@faraday-tech.com, gregkh@linuxfoundation.org
References: <20130903185912.A59316601F4@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903185912.A59316601F4@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 06:59:12PM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=1dd3d123239179fad5de5dc00a6e0014a1918fde
 > Commit:     1dd3d123239179fad5de5dc00a6e0014a1918fde
 > Parent:     10e232c597ac757e7f8600649f7e872e86de190f
 > Author:     Yuan-Hsin Chen <yhchen@faraday-tech.com>
 > AuthorDate: Wed Jun 19 19:53:04 2013 +0000
 > Committer:  Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 > CommitDate: Wed Jul 24 16:04:53 2013 -0700
 > 
 >     usb: host: Faraday fotg210-hcd driver
 >     
 >     FOTG210 is an OTG controller which can be configured as an
 >     USB2.0 host. FOTG210 host is an ehci-like controller with
 >     some differences. First, register layout of FOTG210 is
 >     incompatible with EHCI. Furthermore, FOTG210 is lack of
 >     siTDs which means iTDs are used for both HS and FS ISO
 >     transfer.
 >     
 >     Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>
 >     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

 > +config USB_FOTG210_HCD
 > +	tristate "FOTG210 HCD support"
 > +	depends on USB
 > +	default N
 > +	---help---
 > +	  Faraday FOTG210 is an OTG controller which can be configured as
 > +	  an USB2.0 host. It is designed to meet USB2.0 EHCI specification
 > +	  with minor modification.
 > +
 > +	  To compile this driver as a module, choose M here: the
 > +	  module will be called fotg210-hcd.
 > +

Shouldn't this depend on USB_OTG ?
Seems odd to have OTG related options presented to me when I have that unset.

	Dave

