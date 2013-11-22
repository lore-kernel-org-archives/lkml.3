Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab3KVVNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 16:13:01 -0500
Received: from gate.crashing.org ([63.228.1.57]:48037 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755467Ab3KVVM6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 16:12:58 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Subject: Re: [PATCH 2/2] memory: ti-aemif: add bindings for AEMIF driver
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <528D076A.8070806@ti.com>
Date: Fri, 22 Nov 2013 15:06:52 -0600
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>, grygorii.strashko@ti.com,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C0B815B0-E394-494C-88A2-78A0DBFA23DA@kernel.crashing.org>
References: <1384962416-14862-1-git-send-email-ivan.khoronzhuk@ti.com> <1384962416-14862-3-git-send-email-ivan.khoronzhuk@ti.com> <20131120182102.GK14627@ns203013.ovh.net> <528D076A.8070806@ti.com>
To: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
X-Mailer: Apple Mail (2.1822)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 20, 2013, at 1:03 PM, ivan.khoronzhuk <ivan.khoronzhuk@ti.com> wrote:

> On 11/20/2013 08:21 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>>> +				the chip select signal.
>>> +				Minimum value is 1 (0 treated as 1).
>>> +
>>> +- ti,cs-wsetup:		write setup width, ns
>>> +				Time between the beginning of a memory cycle
>>> +				and the activation of write strobe.
>>> +				Minimum value is 1 (0 treated as 1).
>>> +
>>> +- ti,cs-wstrobe:	write strobe width, ns
>>> +				Time between the activation and deactivation of
>>> +				the write strobe.
>>> +				Minimum value is 1 (0 treated as 1).
>>> +
>>> +- ti,cs-whold:		write hold width, ns
>>> +				Time between the deactivation of the write
>>> +				strobe and the end of the cycle (which may be
>>> +				either an address change or the deactivation of
>>> +				the chip select signal.
>>> +				Minimum value is 1 (0 treated as 1).
>>> +
>>> +If any of the above parameters are absent, current parameter value will be taken
>>> +from the corresponding HW reg.
>>> +
>>> +The name for cs node must be in format csN, where N is the cs number.
>> 
>> this is wired we should use reg instead to represent the cs as done for SPI
>> or a an other property
>> 
>> Best Regards,
>> J.
>> 
> 
> Ok, I will add new property cs-chipselect like following :
> 
> ti,cs-chipselect:	number of chipselect. Indicates on the
> 			aemif driver which chipselect is used
> 			for accessing the memory.
> 			For compatibles "ti,davinci-aemif" and 
> 			"ti,keystone-aemif" it can be in range [0-3].
> 			For compatible "ti,omap-L138-aemif" range is [2-5].
> 
> Is it OK?

Why do you need this? As it was mentioned just use reg:

So you’d have something like:

memory-controller@21000A00 {
	…
	nand:cs2@2 {
		reg = <2 0 0>;
		ranges;
		...

	}:
};

However, I’m confused by the example in which you have:

+		nand@0,0x8000000 {
+			compatible = "ti,davinci-nand";
+			reg = <0 0x8000000 0x4000000
+			       1 0x0000000 0x0000100>;
+
+			.. see davinci-nand.txt
+		};

What chipselects is this on 0 & 1?

- k
			
> 
> -- 
> Regards,
> Ivan Khoronzhuk
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

