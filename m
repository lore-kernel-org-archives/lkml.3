Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816AbaITTu4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 15:50:56 -0400
Received: from smtp-out-215.synserver.de ([212.40.185.215]:1094 "EHLO
	smtp-out-213.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754691AbaITTuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 15:50:55 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 15573
Message-ID: <541DDA9B.40904@metafoo.de>
Date: Sat, 20 Sep 2014 21:50:51 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.8.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com
Subject: Re: [PATCH] i2c: Add generic support passing secondary devices addresses
References: <1409925739-28188-1-git-send-email-jean-michel.hautbois@vodalys.com> <20140920164858.GA2260@katana>
In-Reply-To: <20140920164858.GA2260@katana>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2014 06:49 PM, Wolfram Sang wrote:
> On Fri, Sep 05, 2014 at 04:02:19PM +0200, Jean-Michel Hautbois wrote:
>> Some I2C devices have multiple addresses assigned, for example each address
>> corresponding to a different internal register map page of the device.
>> So far drivers which need support for this have handled this with a driver
>> specific and non-generic implementation, e.g. passing the additional address
>> via platform data.
>
> This raises the first question for me: Are the additional addresses
> configurable? Sadly, I can't find good documentation for the adv7604.
> Otherwise, if I know I have a adv7604 and know its addresses, this
> information should go into the driver and not the DT.
>

They are. The current driver hard codes the other addresses, but that's not 
working when you have multiple adv7604s on the same I2C bus.

- Lars
