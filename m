Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab3HSWXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 18:23:10 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:60266 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab3HSWXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 18:23:09 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
X-AuditID: cbfec37b-b7f306d0000047de-57-52129acb2fb0
Message-id: <52129AC3.5020402@samsung.com>
Date: Mon, 19 Aug 2013 16:22:59 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>, shuahkhan@gmail.com
Subject: Re: [ 00/34] 3.4.59-stable review
References: <20130818203259.653403173@linuxfoundation.org>
 <52125DA9.3090601@samsung.com> <20130819193538.GB24897@kroah.com>
 <201308192214.54917.s.L-H@gmx.de>
In-reply-to: <201308192214.54917.s.L-H@gmx.de>
Content-transfer-encoding: 8bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t9hP93Ts4SCDO4uNbFoXryezeLyrjls
	Fo+eXGSz+PrTwWLBxkeMDqweO2fdZff48DHOY//cNewenzfJBbBEcdmkpOZklqUW6dslcGUc
	mr+auWCbQMXjKw3MDYybeLsYOTgkBEwklp8J7WLkBDLFJC7cW8/WxcjFISSwjFFi58JfLCAJ
	XgFBiR+T74HZzAJmEo9a1jFDFPUySbzcfA2qYyOjxKW1L9khOrQk3rxoYAKxWQRUJWb1TmID
	sdkE1CU+v94BViMkICfRtGQ1M8gVogIREkeXa4KERYBauzf/B1vALLCUUeLMvK1gvcJAia9/
	XkEtW8Qo8eLJdWaQBKeAnsTCpWvZIM6Tlzh45TkLxAJliT+XTzFBvKkosX211QRGkVlIHpqF
	5KFZSLoXMDKvYhQrLU4uKE5KT60w0itOzC0uzUvXS87P3cQIiZPqHYx3v9ocYhTgYFTi4e1Q
	EgoSYk0sK67MPcQowcGsJMIbXwIU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwGgi+nUW2303pzXM
	5nZttT6BzBHvp4bNy03nPtGq2HdU/BLHlx+lXe3H3rV6LvMu6VznrX77feAbm0Mc1xI3Rn/t
	/CojseqBxe2L06eeSan7UHNf/+GsDZ2sLay3ahrd753n2Hp1ku25pBklpfHKq6X1wpISLJwu
	6F19c/1C5NT2f742Uw55MimxFGckGmoxFxUnAgDOdxnscQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2013 02:14 PM, Stefan Lippers-Hollmann wrote:
> Hi
>
> On Monday 19 August 2013, Greg Kroah-Hartman wrote:
>> On Mon, Aug 19, 2013 at 12:02:17PM -0600, Shuah Khan wrote:
>>> On 08/18/2013 02:34 PM, Greg Kroah-Hartman wrote:
> […]
>>> and the following traces in dmesg:
>>> [  124.802169] init: udevtrigger post-stop process (353) terminated
>>> with status 1
>>> [  243.439212] INFO: task crda:723 blocked for more than 120 seconds.
>>
>> What is "crda"?
>>
>> Any luck with bisection?  It should go fast as the majority of patches
>> here are non-x86.
>
> crda is a userspace helper, invoked by udev events, which sets -and
> intersects as needed- the regulatory domain settings for (modern,
> cfg80211 based) wlan hardware based on the device's EEPROM regdom hint,
> local configuration (country code) and eventual IEEE 802.11d hints
> (country IEs) beaconed by access points nearby. It hooks into udev with
> these udev rules (Debian/ 1.1.2-1):
>
> $ grep -v -e ^$ -e ^\# /lib/udev/rules.d/60-crda.rules
> SUBSYSTEM=="ieee80211", ACTION=="add", RUN+="/lib/crda/setregdomain"
>
> $ grep -v -e ^$ -e ^\# /lib/udev/rules.d/85-regulatory.rules
> KERNEL=="regulatory*", ACTION=="change", SUBSYSTEM=="platform", RUN+="/sbin/crda"
>
> Full source is at [2], it should be installed on pretty much every
> distro/ system released with wlan support for the last >>3 years.
>
> There are two iwl4965 patches in this series, which might be among the
> first ones to check - /if/ you actually have that hardware, the second
> one (iwl4965: reset firmware after rfkill off) might also indirectly
> have an effect on blutetooth (via rfkill).
>
> Regards
> 	Stefan Lippers-Hollmann
>
> [1]	http://wireless.kernel.org/en/developers/Regulatory/CRDA
> [2]	https://github.com/mcgrof/crda
>

Greg,

git bisect shows the following patch as the problem:

[ 26/34] genetlink: fix family dump race


-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
