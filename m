Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbaBPMSu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 07:18:50 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.138]:15625 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751477AbaBPMSs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 07:18:48 -0500
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-15.tower-178.messagelabs.com!1392553126!26425680!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Mark Brown <broonie@kernel.org>
CC: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: RE: [RFC V1] mfd: da9063: Add support for production silicon
 variant code
Thread-Topic: [RFC V1] mfd: da9063: Add support for production silicon
 variant code
Thread-Index: AQHPKWf9+CU+DQqgfkW1F75og72Z1Zq1DBLdgAK5ipA=
Date: Sun, 16 Feb 2014 12:18:43 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB78F97D757@SW-EX-MBX02.diasemi.com>
References: <201402131031.s1DAVWrJ023725@swsrvapps-01.diasemi.com>
 <20140214093435.GI3403@lee--X1>
 <6ED8E3B22081A4459DAC7699F3695FB78F97CB13@SW-EX-MBX02.diasemi.com>
 <20140214145643.GA4451@sirena.org.uk>
In-Reply-To: <20140214145643.GA4451@sirena.org.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.50.31]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 February 2014 14:57, Mark Brown [mailto:broonie@kernel.org] wrote:

>On Fri, Feb 14, 2014 at 10:28:38AM +0000, Opensource [Steve Twiss] wrote:
>
>> The previous silicon was only sent out in sample form to selected customers
>> and will no longer be available. I have been informed that the new silicon
>> has been sent out, and everybody should have received the new variant by
>> now.
>
>> The new variant is the only one going into production and the previous silicon
>> variant will no longer be available. Also, the production silicon of DA9063
>> makes an alteration to the registers which makes the two register maps
>> incompatible.

My apologies for not replying to this in time -- it appeared in my inbox after
I had sent RFC V2.

>
>The usual thing if it's straightforward to do so is to keep support for
>old versions even if the early revisions are not expected to be widely
>available.

Yes, I take your point here.

Some registers in the new variant make backwards compatibility easy,
however attempting to combine the two register maps in other components
makes the driver a mess. 

By drawing the line in the probe() function I am requesting that there be no
support for older silicon. I have been requested to do this because that is 
the line that Dialog Semiconductor Ltd wants to impose -- and this is not
just at the level of the S/W driver.

I realise that the Linux community will have different aims however and 
I would like to support those as much as I can.

> We do fairly often see problems with people still using old
>boards for various reasons - the fact that new silicon is available does
>not mean that the old silicon has been retired by users (even if just
>for comparison purposes while new board revisions are being brought up -
>"that worked on the rev A boards, did we break the software?") 

I see -- yes.

I don't see any straightforward way to support some of the components
in parallel, and merging the registers.h file for both variants does make a
mess even before reaching the driver code.

I'm not sure how easy this will be, but if I can retain support for some of
the older variant features already in the kernel I will try to do so during
my upcoming submissions.

Regards,
Steve
