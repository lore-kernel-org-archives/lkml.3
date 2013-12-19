Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab3LSRD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:03:26 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:58681 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab3LSRDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:03:23 -0500
Message-ID: <52B334EF.1090202@cogentembedded.com>
Date: Thu, 19 Dec 2013 21:03:27 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>, josh@joshtriplett.org
CC: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 3/7] drivers: usb: Include appropriate header file in
 hcd.h
References: <Pine.LNX.4.44L0.1312191142501.984-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1312191142501.984-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/19/2013 07:48 PM, Alan Stern wrote:

>>> Of course, people have varying opinions on this issue.  As far as I
>>> know, there is no fixed policy in the kernel about nested includes.

>> True.  I personally prefer the policy of making all headers
>> self-contained, and then only including headers that define things used
>> in the source file.  That has the advantage of not including any
>> unnecessary headers if the dependencies shrink, and not requiring
>> changes to multiple source files if the dependencies grow.

>> Any particular objection to making the headers self-contained?

> I guess it depends on what you mean by "self-contained".  The only
> reasonable definition I can think of at the moment is that you don't
> get any errors or warnings when you compile the .h file by itself.

> But what use is that in practice?  Nobody ever compiles .h files by
> themselves.

    It's enough to verify that a .c file containing the given .h file would 
not cause errors *located in that .h file*. This is not really such an 
improbable situation, e.g. at the early stages of development. I did discover 
header fiel errors this way.

> For that matter, how can you tell that you are including only headers
> that define things used in the source file?

    I still think that's a whole different issue.

> Remove each #include line,
> one at a time, and see if you then get an error?  Do you do this after
> each change to the source file to make sure it remains true over time?

    That's what #include cleanup patches are for. Somebody has to do them from 
time to time when the #include's accumulate -- they tend to accumulate as 
people often forget to remove no longer needed one while removing some feature 
from the .c file.

> My point is that the C language design and compiler infrastructure make
> it virtually impossible to enforce any fixed policy.

    I don't really see how C language design can justify header files that 
once included, require each .c file to #include other headers ahead of them, 
each time such header is used. In my opinion, it's just crazy.

> Alan Stern

WBR, Sergei

