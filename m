Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbbAFQui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:50:38 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277AbbAFQuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:50:37 -0500
Message-ID: <54AC1258.2070004@nod.at>
Date: Tue, 06 Jan 2015 17:50:32 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mariusz Gorski <marius.gorski@gmail.com>
CC: Evgeniy Polyakov <zbr@ioremap.net>, David Fries <David@fries.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] w1: slaves: w1_therm: Add sysfs entry for current
 temperature
References: <1420554596-10250-1-git-send-email-marius.gorski@gmail.com> <CAFLxGvwXN0XKQ_fX7pS=dpZf+SoysN_fH8iAgtyMYG9dX+6oAQ@mail.gmail.com> <20150106161205.GA2912@firebird>
In-Reply-To: <20150106161205.GA2912@firebird>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.01.2015 um 17:12 schrieb Mariusz Gorski:
> On Tue, Jan 06, 2015 at 04:01:47PM +0100, Richard Weinberger wrote:
>> On Tue, Jan 6, 2015 at 3:29 PM, Mariusz Gorski <marius.gorski@gmail.com> wrote:
>>> DS18B20 and it's brothers are pretty popular in the RaspberryPi world
>>> when it comes to temperature measurement. All tutorials on the Internet
>>> use the same way of parsing the output of the w1_slave sysfs file.
>>> These patches add a dedicated sysfs entry called 'temp' whose only job
>>> is to output the current temperature.
>>
>> And what is the benefit of this patches?
> 
> Well, instead of having to parse the output of w1_slave:
> 
> $ cat w1_slave 
> 4d 01 55 00 7f ff 0c 10 fd : crc=fd YES
> 4d 01 55 00 7f ff 0c 10 fd t=20812
> 
> the userspace program gets only the interesting information,
> which usually is the current temparture:

A sane user would also check the CRC.

IMHO it is up to the user to format the output for its needs.
Some may want "20812", some "20.8", some else maybe "20.8°C".
Let it up to the user.
Any trivial awk/cut/etc... oneliner would do it.

Thanks,
//richard
