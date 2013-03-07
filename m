Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759748Ab3CGUJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 15:09:23 -0500
Received: from smarthost3.mail.uk.easynet.net ([212.135.6.13]:36667 "EHLO
	smarthost3.mail.uk.easynet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758443Ab3CGUJU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 15:09:20 -0500
From: Jean-Francois Dagenais <DagenaisJ@Sonatest.com>
To: Olivier KSIKES <olivier@okprods.com>
CC: open list <linux-kernel@vger.kernel.org>
Subject: Re: w1_ds2408 linux driver
Thread-Topic: w1_ds2408 linux driver
Thread-Index: AQHODq+hzT4V6+pN0kSL+qstSY9rQJiaweUA
Date: Thu, 7 Mar 2013 20:09:14 +0000
Message-ID: <47BBCF14-C7BC-4C35-826A-52A50EFB8B4B@sonatest.com>
References: <51238FBA.9050600@okprods.com>
In-Reply-To: <51238FBA.9050600@okprods.com>
Accept-Language: en-CA, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.128.91]
x-exclaimer-md-config: 7c1584ba-e595-4fa0-82b4-f84c142522ec
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1A56EFDEF2CED545B92C50063EA91341@Sonatest.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Mailshell-score: 2, threshold=98, smtpSenderIP=212.56.87.3
	 utc=<2013-03-07 20:09:18>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2013-02-19, at 9:44 AM, Olivier KSIKES wrote:

> Dear Mr Dagenais,
> 
> I have just tried your w1-ds2408 linux driver on a TP link mini router running openwrt with w1-gpio. I was able to successfully update a 2408 outputs by writing a byte to the /output file.
> However, I would like to drive an LCD screen, and this method seems limited to 3/4 chars per second.
> 
> I had little more luck driving the 2408 thru the generic w1 driver (using the rw file), where I reached around 25 bytes/s.
> This is however far from the actual 1wire bus capabilities.
> 
> Thus, I'm wondering if there is a faster way to output a series of bytes to the 2408 using your driver?
> Is there any doc available apart from w1_ds2408.c comments?
> 
> With best regards and congratulations for your great work,
> 
> Olivier Ksikes

Here are my test results.

I have a simple main() that opens the /sys/bus/w1/devices/29-0000000xyz/output
file and keeps it open.

I sweep from 0 to 255 in a tight loop that simply does

   for (int i=0; i <= 1024; ++i) {
      file.putChar(i);
      file.seek(0);
   }
   return 0;

I invoke this using "time" and do 1024/timespent to get:
Current  driver (w/read-back ): ~48 chars/seconds
Improved driver (wo/read-back): ~98 chars/seconds

patch will follow...

Cheers.




