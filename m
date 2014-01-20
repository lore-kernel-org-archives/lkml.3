Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaATRdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 12:33:13 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61720 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaATRdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 12:33:09 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-79-52dd5dd307ad
Message-id: <52DD5DC5.3000908@samsung.com>
Date: Mon, 20 Jan 2014 18:32:53 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <Mark.Rutland@arm.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH RFC 04/10] base: power: Add generic OF-based power domain
 look-up
References: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
 <1389469372-17199-5-git-send-email-tomasz.figa@gmail.com>
 <20140116163409.GD25540@e102568-lin.cambridge.arm.com>
In-reply-to: <20140116163409.GD25540@e102568-lin.cambridge.arm.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t/xK7qXY+8GGXzfz2KxccZ6Vov5R86x
	WvS/Wchq0bx4PZvFuVcrGS16F1xls5g1ZS+TxabH11gtLu+aw2bxufcIo8WM8/uYLG5f5rV4
	8/sFu8XS6xeZLO6eOspmMWH6WhaLM6cvsVq07j3CbvHqYBuLxapdfxgdRDzWzFvD6NHS3MPm
	cbmvl8lj56y77B4rl39h81i85yWTx6ZVnWwe++euYffYvKTeY8vVdhaPvi2rGD1WrP7O7vF5
	k5zHxrmhAXxRXDYpqTmZZalF+nYJXBnzv0xmL2jirli8/B1zA+N1ji5GTg4JAROJI1v+s0PY
	YhIX7q1n62Lk4hASWMoo8ezaXhaQhJDAZ0aJbxsZQWxeAS2J9vefmUBsFgFViZ5505lBbDYB
	NYnPDY/YQGxRgQiJv/PWQ9ULSvyYfA9sjghQfOqV92ALmAXus0ls/bcKrEFYIFxi+6z5zBCb
	dzFKLJhyCKyDU8BZorHxG9gkZgFbiQXv17FA2PISm9e8ZZ7AKDALyZJZSMpmISlbwMi8ilE0
	tTS5oDgpPddIrzgxt7g0L10vOT93EyMkfr/uYFx6zOoQowAHoxIPb4fHnSAh1sSy4srcQ4wS
	HMxKIrwNgXeDhHhTEiurUovy44tKc1KLDzEycXBKNTAy2NgqH98ec8ZyWkDeX+kTh2zENQ+E
	NecxlMj9FRd7kb1O4fViMxG7PLlFoZcso357/ZjdMlPgOX8bxwqtaTM1F9b9+DZlvuf3O4JG
	9s5pHCE7Ex68n9B07pK76lX3wOuiWb7GxnsSdRwnTXry3YjHJifOL9Lj8aIniVEF5qHRuQmr
	VHm3+iqxFGckGmoxFxUnAgDSgpy3vQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lorenzo,

On 16.01.2014 17:34, Lorenzo Pieralisi wrote:
> Hi Tomasz,
>
> thank you for posting this series. I would like to use the DT bindings
> for power domains in the bindings for C-states on ARM:
>
> http://comments.gmane.org/gmane.linux.power-management.general/41012
>
> and in particular link a given C-state to a given power domain so that the
> kernel will have a way to actually check what devices are lost upon C-state
> entry (and for devices I also mean CPU peripheral like PMUs, GIC CPU IF,
> caches and possibly cpus, all of them already represented with DT nodes).
>
> I have a remark:
>
> -  Can we group device nodes under a single power-domain-parent so that
>     all devices defined under that parent won't have to re-define a
>     power-domain property (a property like interrupt-parent, so to speak)
>
> What do you think ?

Hmm, I can see potential benefits of such construct on platforms with 
clear hierarchy of devices, but to make sure I'm getting it correctly, 
is the following what you have in mind?

soc-domain-x@12340000 {
	compatible = "...";
	reg = <...>;
	power-domain-parent = <&power_domains DOMAIN_X>;

	device@1000 {
		compatible = "...";
		// inherits power-domain = <&power_domains DOMAIN_X>
	};

	device@2000 {
		compatible = "...";
		// inherits power-domain = <&power_domains DOMAIN_X>
	};
};

Best regards,
Tomasz
