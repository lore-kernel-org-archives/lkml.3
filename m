Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbaLBPMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 10:12:55 -0500
Received: from smtp-out-006.synserver.de ([212.40.185.6]:1098 "EHLO
	smtp-out-006.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177AbaLBPMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 10:12:53 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 27141
Message-ID: <547DD6F0.6060006@metafoo.de>
Date: Tue, 02 Dec 2014 16:12:48 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>,
        Harini Katakam <harinikatakamlinux@gmail.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "soren.brinkmann@xilinx.com" <soren.brinkmann@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "vishnum@xilinx.com" <vishnum@xilinx.com>
Subject: Re: [PATCH 3/4] devicetree: bindings: Add defeature-repeated-start
 property for Cadence I2C
References: <1417514749-24319-1-git-send-email-harinik@xilinx.com> <1417514749-24319-4-git-send-email-harinik@xilinx.com> <20141202111907.GC23671@leverpostej> <CAFcVECLtPx6shBXJbg9Uf_8fnhkMoO1zpoxGcdda7PSA7z_2rA@mail.gmail.com> <20141202125203.GA4072@katana> <CAFcVECJwFoFd6GrmF282CG+fELnYb=FNCTDq=RYKky_dHha=Jg@mail.gmail.com> <20141202131611.GC4072@katana> <CAFcVECKMqACtumHZGHbToUUSjd_dWCcLbu=_ZjNnnGdAZQ_3fg@mail.gmail.com> <20141202141548.GA5883@katana>
In-Reply-To: <20141202141548.GA5883@katana>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 03:15 PM, Wolfram Sang wrote:
>>> What do you do when disable repeated start? Sending STOP and START? If
>>> so, this is really something different than repeated start. By using
>>> I2C_FUNC_I2C a user expects repeated start, so if the HW does not
>>> support it, we should say so and don't try to emulate it with something
>>> different.
>>
>> Yes, we send stop.
>
> As said before, this is wrong. Another master could interfere between
> the messages when using stop+start. This is no replacement for repeated
> start.

More importantly a lot of I2C slaves also reset their internal state machine 
on a stop. So e.g. if reading a register is implemented by doing 
start,write,repeated start,read,stop and you replace that with 
start,write,stop,start,read,stop you'll always read register zero instead of 
the register you wanted to read.

- Lars

