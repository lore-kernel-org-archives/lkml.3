Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaE1Lix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 07:38:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbaE1Liw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 07:38:52 -0400
Message-ID: <5385CAA6.7010708@redhat.com>
Date: Wed, 28 May 2014 13:38:14 +0200
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: xjtuwjp@gmail.com, lindar_liu@usish.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: pm8001: pm8001_hwi.c:  Fix for possible null pointer
 dereference
References: <1400429640-11489-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <20140528112811.GD11953@infradead.org>
In-Reply-To: <20140528112811.GD11953@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 01:28 PM, Christoph Hellwig wrote:
> On Sun, May 18, 2014 at 06:14:00PM +0200, Rickard Strandqvist wrote:
>> There is otherwise a risk of a possible null pointer dereference.
>>
>> Was largely found by using a static code analysis program called cppcheck.
> I can't see how dev->lldd_dev would be NULL here.

The analysis program likely can't know that, the reason for this report 
it that dev->lldd_dev is tested for not being null several lines below -
http://lxr.free-electrons.com/source/drivers/scsi/pm8001/pm8001_hwi.c#L4447
So the other option is to remove this^ test.

