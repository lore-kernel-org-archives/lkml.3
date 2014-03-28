Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaC1IAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 04:00:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38057 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaC1IAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 04:00:38 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-ec-53352c259596
Date: Fri, 28 Mar 2014 09:00:31 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: ego@linux.vnet.ibm.com, Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH] cpufreq: don't print value of .driver_data from core
Message-id: <20140328090031.5bb9a01f@amdc2363>
In-reply-to: <20140327112602.GD27777@in.ibm.com>
References: <2490cd0aaeaaeb88131c8089d491c485f08da5da.1395914766.git.viresh.kumar@linaro.org>
 <20140327104842.GB27777@in.ibm.com>
 <CAKohpombz9jzAs-_mpBNJyTJrrvvXVQ1L0V8fyKmB1vXpSPjmQ@mail.gmail.com>
 <20140327112602.GD27777@in.ibm.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsVy+t9jQV1VHdNggw+fBS2eNv1gt/ix6gOr
	xftDz5gtLu+aw2bxufcIo8XJW5OZLM6cvsRqcfnrdWaLlo/rmSw2fvVw4PK4c20Pm8eDQ5tZ
	PG7/e8zsseVqO4vH501yAaxRXDYpqTmZZalF+nYJXBlXJp5lKVgnWdHys5+9gfG7cBcjB4eE
	gInEoknlXYycQKaYxIV769m6GLk4hASmM0qseHaCCcL5xShxdtNDRpAqFgFViT+Hz7KA2GwC
	ehKf7z5lArFFBJwkbnz+wwrSwCywjlni6YXPYEXCAp4SP+c2gRXxAjW8PLaVFcTmFDCQuPZ2
	P9SGT4wS5ya9YgdJ8AtISrT/+8EMcZOdxLlPG9ghmgUlfky+BzaUWUBLYvO2JlYIW15i85q3
	zBMYBWchKZuFpGwWkrIFjMyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYKj45n0DsZVDRaH
	GAU4GJV4eGdYmQQLsSaWFVfmHmKU4GBWEuF9qmwaLMSbklhZlVqUH19UmpNafIhRmoNFSZz3
	YKt1oJBAemJJanZqakFqEUyWiYNTqoExZm0Rh6Wz9oTW6KOTIs5PKPQ9fJDxntqGimCf1FMs
	Snd71qwu5gg5vKAtqbxix7Wzopc/6u1mvpBiu1i2bW71i+97ODb1PZs1ZfmmB2zN4SVhu5vs
	9q+TvjTbrGbV8Xpvo25n/71Hp9arXbm8St3i+UTmvqrVYrEND7I+XTw9reThofkGLK18SizF
	GYmGWsxFxYkAd+KIJIoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gautham,

> On Thu, Mar 27, 2014 at 04:29:37PM +0530, Viresh Kumar wrote:
> > On 27 March 2014 16:18, Gautham R Shenoy <ego@linux.vnet.ibm.com>
> > wrote:
> > > So after this patch, driver_data is only going to be used by
> > > drivers which want an "unsigned int" value to be saved along with
> > > the frequency in the frequency_table and for those who want to
> > > overload its interpretation to indicate BOOST.
> > >
> > > From the core's stand point, it is useful only for determining
> > > whether a frequency is BOOST frequency or not.
> > 
> > Yes.
> > 
> > > So, wouldn't it be logical to allow drivers maintain their own
> > > driver data since the core is anyway not interested in it, and
> > > change this .driver_data to "flags" or some such which can
> > > indicate boost ?
> > 
> > We can add another field .flags in case Rafael doesn't accept the
> > other proposal I sent for fixing BOOST issue.
> 
> Even with that patch, the .driver_data won't be opaque. And that's not
> good. Because, while some driver might not be explicitly setting the
> value of .driver_data to 0xABABABAB, it might want to store the value
> obtained at runtime into this field. And it could so happen
> that at runtime this value is 0xABABABAB.

The .driver_data initially stored the index of the freq_table. Even the
name was ".index" not .driver_data. The "index" name was informative
and reflected the purpose of the field. For this reason the BOOST
marker was fitted there, since BOOST is somewhat extra state.

Then the name was chaged to .drviver_data. This name indicates that
driver specific information can be stored there (in the uint32 format).

It would work if we stored there only flags (like it is now). However
Gutham proposed idea to store there the voltage value - preferably
stored as int.

For me it seems, like we are trying to mix arbitrary values and
predefined flags in one variable. In my opinion we should
split .driver_data field to two separate ones - namely .flags and
.driver_data.

Another solution, but NOT recommended by me, would be to split this
field to have 16 bits for flags (upper) and lower 16 bits for values.


> 
> > 
> > But the point behind keeping .driver_data field here was: many
> > drivers have some information attached to each frequency and they
> > are closely bound to each other. And so it made more sense to keep
> > them together. This is still used by many drivers and I wouldn't
> > like them to maintain separate arrays for keeping this information.
> > They are so much bound to the frequencies at the same index, that
> > keeping them separately wouldn't be a good idea.
> 
> I understand this part. However there might be more data than an
> "unsigned int" that the drivers would like to be bound at the same
> index. Voltage information, for instance.
> 
> > 
> --
> Thanks and Regards
> gautham.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
