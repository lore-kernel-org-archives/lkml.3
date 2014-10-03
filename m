Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbaJCTnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 15:43:00 -0400
Received: from lists.s-osg.org ([54.187.51.154]:39280 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979AbaJCTm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 15:42:57 -0400
Message-ID: <542EFC36.1010306@osg.samsung.com>
Date: Fri, 03 Oct 2014 13:42:46 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Davidlohr Bueso <dave@stgolabs.net>
CC: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        colin.king@canonical.com, luto@amacapital.net,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH v3 3/5] selftests/ipc: change test to use ksft framework
References: <cover.1412349412.git.shuahkh@osg.samsung.com> <fb7ed86d44adbc7f97f9e42b314e4fce5616959e.1412349412.git.shuahkh@osg.samsung.com> <1412357993.20838.4.camel@linux-t7sj.site>
In-Reply-To: <1412357993.20838.4.camel@linux-t7sj.site>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2014 11:39 AM, Davidlohr Bueso wrote:
> On Fri, 2014-10-03 at 09:36 -0600, Shuah Khan wrote:
>>  	msgque.key = ftok(argv[0], 822155650);
>>  	if (msgque.key == -1) {
>> -		printf("Can't make key\n");
>> -		return -errno;
>> +		printf("Can't make key: %d\n", -errno);
> 
> So printing a numeric value is quite useless when users actually run
> into these errors -- which is why I like err() so much. How about using
> strerror() instead?
> 

Yes. using perror() does give better information. There are other
places in this file that use errno. How about I make that a separate
patch and catch all of them at once to use perror() as a follow-up
change? That way I fix all at once without adding more changes to
this patch.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
