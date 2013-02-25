Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475Ab3BYLEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 06:04:50 -0500
Received: from blu0-omc2-s26.blu0.hotmail.com ([65.55.111.101]:43675 "EHLO
	blu0-omc2-s26.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759120Ab3BYLEs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 06:04:48 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Feb 2013 06:04:48 EST
X-EIP: [FbNAPuspUfWXRR2ZOM1tYhzECD1TN0pf0AQgA+vxe0o=]
X-Originating-Email: [emilio@elopez.com.ar]
Message-ID: <BLU0-SMTP837DD4DF438223EBC6536A8AF30@phx.gbl>
Date: Mon, 25 Feb 2013 07:58:33 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130112 Icedove/17.0.2
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, shawn.guo@linaro.org, mark.langsdorf@calxeda.com,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] cpufreq: highbank: do not initialize array with a loop
References: <1361725277-5125-1-git-send-email-emilio@elopez.com.ar> <CAOh2x=nDZpBaqjzO22k66Bb30mVEhAdy02EFDP9RDibA50Sx7A@mail.gmail.com>
In-Reply-To: <CAOh2x=nDZpBaqjzO22k66Bb30mVEhAdy02EFDP9RDibA50Sx7A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 25 Feb 2013 10:58:38.0620 (UTC) FILETIME=[10D31DC0:01CE1347]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

El 25/02/13 00:41, Viresh Kumar escribió:
> On Sun, Feb 24, 2013 at 10:31 PM, Emilio López <emilio@elopez.com.ar> wrote:
>> As uninitialized array members will be initialized to zero, we can
>> avoid using a for loop by setting a value to it.
>>
>> Signed-off-by: Emilio López <emilio@elopez.com.ar>
>> ---
>> Note that I don't own any device using this driver, it has only been compile
>> tested, but it shouldn't cause any issues.
>>
>>  drivers/cpufreq/highbank-cpufreq.c | 6 +-----
>>  1 file changed, 1 insertion(+), 5 deletions(-)
>>
>> diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
>> index 66e3a71..30d4ae1 100644
>> --- a/drivers/cpufreq/highbank-cpufreq.c
>> +++ b/drivers/cpufreq/highbank-cpufreq.c
>> @@ -28,13 +28,9 @@
>>
>>  static int hb_voltage_change(unsigned int freq)
>>  {
>> -       int i;
>> -       u32 msg[HB_CPUFREQ_IPC_LEN];
>> +       u32 msg[HB_CPUFREQ_IPC_LEN] = {HB_CPUFREQ_CHANGE_NOTE};
>>
>> -       msg[0] = HB_CPUFREQ_CHANGE_NOTE;
>>         msg[1] = freq / 1000000;
> 
> I think this can also be part of the definition of array, isn't it?
> 
> So it would be something like:
> 
> u32 msg[HB_CPUFREQ_IPC_LEN] = {HB_CPUFREQ_CHANGE_NOTE, freq / 1000000};
> 

I incorrectly assumed that sparse would complain, but after testing I
see it doesn't. Thanks for pointing it out, I'll send a v2 in a minute.

Emilio
