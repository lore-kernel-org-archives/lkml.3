Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbaK0OZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:25:59 -0500
Received: from mout.web.de ([212.227.15.4]:57659 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaK0OZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:25:58 -0500
Message-ID: <54773467.40109@users.sourceforge.net>
Date: Thu, 27 Nov 2014 15:25:43 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 2/2] staging: android: ion: One function call less in
 ion_buffer_create() after error detection
References: <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54722893.6020301@users.sourceforge.net> <54722AF8.3000609@users.sourceforge.net> <20141126214226.GB31904@kroah.com>
In-Reply-To: <20141126214226.GB31904@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:I41pYJIetEI8x/4lDvbTK971ZGrfO6slkY/Yo76Eq+rqP1fCoRd
 Ye/MwIUAt6KfZu343b57oaDp7eSqfYlf7+5GuomF15HLIx2Q7Vg3WA+usx+nwZVLz0ernMN
 iLY3U7sszzmlbQ9Dg5WcRb4ILjA8HJgjFj4syThgN9cYea8upF0PkNuIkJwecAAUyJX9dya
 hk7x9E79bkIRd832osPXA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
>> index df12cc3..7a26b85 100644
>> --- a/drivers/staging/android/ion/ion.c
>> +++ b/drivers/staging/android/ion/ion.c
>> @@ -226,7 +226,7 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
>>  		buffer->pages = vmalloc(sizeof(struct page *) * num_pages);
>>  		if (!buffer->pages) {
>>  			ret = -ENOMEM;
>> -			goto err1;
>> +			goto err2;
>>  		}
>>  
>>  		for_each_sg(table->sgl, sg, table->nents, i) {
>> @@ -262,7 +262,6 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
>>  err:
>>  	heap->ops->unmap_dma(heap, buffer);
>>  	heap->ops->free(buffer);
>> -err1:
>>  	vfree(buffer->pages);
>>  err2:
> 
> Now we have "err" and "err2", which doesn't make much sense,
> please fix up.

How do you want this source code to be improved?
Should I introduce longer names for the affected jump labels?

Regards,
Markus
