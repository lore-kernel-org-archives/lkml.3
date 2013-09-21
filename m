Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab3IUPqe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 11:46:34 -0400
Received: from smtprelay0122.hostedemail.com ([216.40.44.122]:50791 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751857Ab3IUPqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 11:46:33 -0400
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Sep 2013 11:46:32 EDT
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::,RULES_HIT:41:152:355:379:599:800:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:3138:3139:3140:3141:3142:3352:3865:3867:3870:4321:4385:5007:6119:7652:7875:7903:10004:10400:10848:11232:11658:11914:12043:12517:12519:12555:12740:13069:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crib40_7d3f86c256116
X-Filterd-Recvd-Size: 1661
User-Agent: K-9 Mail for Android
In-Reply-To: <20130921143255.GS13318@ZenIV.linux.org.uk>
References: <20130920164732.GA31520@redhat.com> <20130921143255.GS13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: tracing: don't stuff stale pointers in filp->private_data
From: Steven Rostedt <rostedt@goodmis.org>
Date: Sat, 21 Sep 2013 11:37:30 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <cd5db43e-160e-448a-9708-3c5e44c0d34c@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Or make the assignment in an else block.

-- Steve


Al Viro <viro@ZenIV.linux.org.uk> wrote:
>On Fri, Sep 20, 2013 at 12:47:32PM -0400, Dave Jones wrote:
>> Probably harmless, but still not a nice thing to do.
>> 
>> Signed-off-by: Dave Jones <davej@fedoraproject.org>
>> 
>> diff --git a/kernel/trace/trace_events.c
>b/kernel/trace/trace_events.c
>> index 368a4d5..75d3556 100644
>> --- a/kernel/trace/trace_events.c
>> +++ b/kernel/trace/trace_events.c
>> @@ -1124,6 +1124,7 @@ static int system_tr_open(struct inode *inode,
>struct file *filp)
>>  	if (ret < 0) {
>>  		trace_array_put(tr);
>>  		kfree(dir);
>> +		dir = NULL;
>>  	}
>>  
>>  	filp->private_data = dir;
>
>Er...  Why not simply return ret; instead?

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
