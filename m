Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab3FCJva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:51:30 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:52814 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab3FCJv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:51:27 -0400
MIME-Version: 1.0
In-Reply-To: <51AC15FA.4060800@synopsys.com>
References: <20130530211944.05F4D3E0A90@localhost> <1370014348-21121-1-git-send-email-christian.ruppert@abilis.com>
 <alpine.LFD.2.02.1305311835040.2905@ionos> <20130531221814.534DF3E08FE@localhost>
 <51AC15FA.4060800@synopsys.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 3 Jun 2013 10:51:06 +0100
X-Google-Sender-Auth: vlbMLlUwB6iTfTfPbJHRe-5Eo4U
Message-ID: <CACxGe6se9rqOdLAqj7XQ+Awa5HP+2k1t7pN1AYOAPdiL2o3AjQ@mail.gmail.com>
Subject: Re: [PATCH V3] irqchip: Add TB10x interrupt controller driver
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 5:05 AM, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
> On 06/01/2013 03:48 AM, Grant Likely wrote:
>> If I were working on this system I'd drop the
>> snps,arc700-intc node entirely and have a single abilis,tb10x-intc that
>> encapsulated the properties of both (you would of course want to share
>> handler functions for the 'normal' inputs without the custom features).
>> That would eliminate the goofyness of listing 27 separate interrupts in
>> the abilis,tb10x-ictl interrupts property.
>
> But how is this different from other systems with a primary in-core intc and a
> cascaded external intc. How do they do it. I guess I need to read up more on this.

Usually cascaded irq controllers have multiple irqs multiplexed onto a
single irq on the parent controller. It's the 1:1 situation that makes
this controller odd.

g,
