Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935262Ab3DHQmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:42:33 -0400
Received: from relay1.sgi.com ([192.48.179.29]:56545 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935072Ab3DHQmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:42:31 -0400
Message-ID: <5162F375.6050500@sgi.com>
Date: Mon, 8 Apr 2013 11:42:29 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Woodhouse <dwmw2@infradead.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH resend] fs/proc: Move kfree outside pde_unload_lock
References: <515D9F8A.2060505@sgi.com> <1365090819-25448-1-git-send-email-nzimmer@sgi.com> <20130404161140.GR21522@ZenIV.linux.org.uk> <515DB465.1060004@sgi.com> <20130404204459.GU21522@ZenIV.linux.org.uk> <515F0456.9040803@sgi.com> <20130405173623.GE4068@ZenIV.linux.org.uk> <515F3A71.9080008@sgi.com> <20130405210042.GH4068@ZenIV.linux.org.uk> <5162E36F.5020305@sgi.com> <20130408155847.GS4068@ZenIV.linux.org.uk>
In-Reply-To: <20130408155847.GS4068@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.145]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 10:58 AM, Al Viro wrote:
> On Mon, Apr 08, 2013 at 10:34:07AM -0500, Nathan Zimmer wrote:
>> On 04/05/2013 04:00 PM, Al Viro wrote:
>>> On Fri, Apr 05, 2013 at 03:56:17PM -0500, Nathan Zimmer wrote:
>>>
>>>> That didn't produce anything.  I'll run some bisections over the
>>>> weekend and see what I can sort out.
>>> *Ugh*
>>>
>>> I'd try to build with DEBUG_KMEMLEAK and slapped printks on the entry
>>> and exit from close_pdeo().  If that doesn't show anything interesting,
>>> it's probably unrelated to procfs...
>> My bisection pointed me to this commit:  e41efbf13c15
>> At this point I am assuming my issue is unrelated to procfs.
> Huh?  That commit simply moves three functions and one struct from one file to
> another...
Yea, I was hoping it made more sense to you then it did do me.
I have some lab time later.  I'll verify that is the problem commit.
