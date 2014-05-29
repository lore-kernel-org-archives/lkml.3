Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaE2XF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 19:05:26 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:51814 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaE2XFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 19:05:24 -0400
MIME-Version: 1.0
In-Reply-To: <5385CAA6.7010708@redhat.com>
References: <1400429640-11489-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140528112811.GD11953@infradead.org>
	<5385CAA6.7010708@redhat.com>
Date: Fri, 30 May 2014 01:05:22 +0200
Message-ID: <CAFo99gbJQBQbHKz3nxZfW_RMGjHbYKbCeAPSghGkbcJC5u4qLg@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm8001: pm8001_hwi.c: Fix for possible null pointer dereference
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Tomas Henzl <thenzl@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Wang Jinpu <xjtuwjp@gmail.com>,
        lindar_liu <lindar_liu@usish.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Quite rightly, this is what cppcheck reacts.
Ok, I'll send a patch for that instead then.


Best regards
Rickard Strandqvist


2014-05-28 13:38 GMT+02:00 Tomas Henzl <thenzl@redhat.com>:
> On 05/28/2014 01:28 PM, Christoph Hellwig wrote:
>> On Sun, May 18, 2014 at 06:14:00PM +0200, Rickard Strandqvist wrote:
>>> There is otherwise a risk of a possible null pointer dereference.
>>>
>>> Was largely found by using a static code analysis program called cppcheck.
>> I can't see how dev->lldd_dev would be NULL here.
>
> The analysis program likely can't know that, the reason for this report
> it that dev->lldd_dev is tested for not being null several lines below -
> http://lxr.free-electrons.com/source/drivers/scsi/pm8001/pm8001_hwi.c#L4447
> So the other option is to remove this^ test.
>
