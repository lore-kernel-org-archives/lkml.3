Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaLMWXW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 17:23:22 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:49861 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaLMWXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 17:23:20 -0500
MIME-Version: 1.0
In-Reply-To: <20141213174640.GA18961@earth.universe>
References: <20141211214801.4127.93914.stgit@notabene.brown>
 <20141211215943.4127.24792.stgit@notabene.brown> <20141212115920.4277AC408F1@trevor.secretlab.ca>
 <20141213174640.GA18961@earth.universe>
From: Grant Likely <grant.likely@linaro.org>
Date: Sat, 13 Dec 2014 22:22:59 +0000
X-Google-Sender-Auth: GtD_pFQE5kz9a1vIPPdNug6UM28
Message-ID: <CACxGe6uTXxrnUZi95mb7t6FOwbvjy3cVpz=mmB6H85OFBLW=8g@mail.gmail.com>
Subject: Re: [PATCH 1/3] TTY: add support for "tty slave" devices.
To: Sebastian Reichel <sre@kernel.org>
Cc: NeilBrown <neilb@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 5:46 PM, Sebastian Reichel <sre@kernel.org> wrote:
> Hi,
>
> On Fri, Dec 12, 2014 at 11:59:20AM +0000, Grant Likely wrote:
>> [...]
>> > --- a/Documentation/devicetree/bindings/serial/of-serial.txt
>> > +++ b/Documentation/devicetree/bindings/serial/of-serial.txt
>> > @@ -39,6 +39,10 @@ Optional properties:
>> >    driver is allowed to detect support for the capability even without this
>> >    property.
>> >
>> > +Optional child node:
>> > +- a platform device listed as a child node will be probed and
>> > +  powered-on whenever the tty is in use (open).
>> > +
>>
>> The biggest concern I have is what happens to nodes that already have
>> child devices that /don't/ match this use case? It is possible that some
>> UART nodes already have a child node used to store other data. There are
>> two ways to handle this; 1) add a new bool property that indicates the
>> child nodes are tty slave devices, or 2) Make each uart driver
>> explicitly enable the feature so that driver authors can check if it is
>> a problem for that device. I personally would suggest #1 because then it
>> can be enabled in generic code.
>
> maybe simple depend on the compatible value? If the UART node has
> child nodes to store other random data it should not have a
> compatible value?

That's not a given. It is entirely possible that drivers have used
compatible in the child nodes.

However, I may be stirring up trouble for nothing. We could enable it
for all child nodes that have a compatible value, and then blacklist
any parent nodes that want to use a different behaviour. If someone
complains then we will fix it.

g.
