Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab3FFKcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:32:01 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:60280 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932163Ab3FFKb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:31:59 -0400
Message-ID: <51B0651D.3090902@itdev.co.uk>
Date: Thu, 06 Jun 2013 11:31:57 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface
 via sysfs
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk> <7380889.l4hHqCT0mm@dtor-d630.eng.vmware.com> <51AF8730.4010507@itdev.co.uk> <1717403.GgHsbyUkDZ@dtor-d630.eng.vmware.com> <51AFA02B.3000604@itdev.co.uk> <20130605210715.GA16013@core.coreip.homeip.net> <51AFAF6D.7050204@itdev.co.uk> <20130606100346.GC1883@sirena.org.uk>
In-Reply-To: <20130606100346.GC1883@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Wed, Jun 05, 2013 at 10:36:45PM +0100, Nick Dyer wrote:
>> Run-time examples would be adjusting noise suppression or touch suppression
>> parameters based on something going on in the app layer (eg having
>> different parameters during unlock screen), or tuning report rates based on
>> application requirements, ot to inspect debug data if the touch sensor is
>> faulty. You might say, well we should implement an kernel driver interface
>> for these requirements, but they will vary hugely between different
>> products. We are trying to keep the driver as generic as possible and push
> 
> If this interface varies dramatically between products then that sounds
> like a badly designed interface.  Obviously the way the interface is
> being used would be likely to vary between products but what you're
> talking about sounds like parameter get/set stuff which sounds pretty
> generic to me.  What userspace chooses to do with the parameters is of
> course another story.

The underlying design is called Object Protocol by Atmel, and defines a
method where the the i2c address space starts with a table defining the
types and locations of various objects. Each object contains many
parameters, most of them are simple get/set as you describe, but many
objects have considerably more dynamic behaviours and interactions.

The Object Protocol itself is generic, but the objects themselves are
different on different maXTouch chips and firmware versions. The objects
may change in size, or be added/removed. The protocol is designed to be
flexible and allow rapid firmware development without having to
continuously update tools.

Having to define every parameter in each object (there are thousands) in
the kernel driver would be impractically technically, since it would result
in a huge, and constantly updating API, which would be always out-of-date,
and impossible to support.

Also, I'm afraid it would also be impractical legally, since it would
breach the NDA terms that Atmel require on these parameter definitions.

>> product-specific complexity to user space. Hence exposing the register map
>> and implementing user-space libraries to deal with this kind of customisation.
> 
> This sounds like a bad design decision for Linux, it's just asking for
> fragility if userspace can go randomly poking round the entire register
> map of the device with nothing coordinating with the driver code.

It works very well in practice. This same abstraction is used across
maXTouch products on many platforms to provide tool support. I agree that
its use should be restricted to system programs.
