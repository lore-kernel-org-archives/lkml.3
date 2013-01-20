Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab3ATQPF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 11:15:05 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:37042 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab3ATQPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 11:15:03 -0500
MIME-Version: 1.0
In-Reply-To: <50FBF0D7.703@ladisch.de>
References: <CAAMvbhGM+s0LKJVqR8GWz4LkBhSZCCT_xa2qh=dFjV8A92jqOg@mail.gmail.com>
	<50FBF0D7.703@ladisch.de>
Date: Sun, 20 Jan 2013 16:06:48 +0000
Message-ID: <CAAMvbhHJij19FS1ohUTShCGOT=mHbHT=iMfC0S8nRCzp8m+Zyg@mail.gmail.com>
Subject: Re: Comparing linux kernel trees.
From: James Courtier-Dutton <james.dutton@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: LKML Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 January 2013 13:27, Clemens Ladisch <clemens@ladisch.de> wrote:
> James Courtier-Dutton wrote:
>> I have been given a linux kernel sources tar file.
>> It contains a modified version of the linux kernel.
>> It is just source files, without any "git" history.
>> What I would like to do is compare this with the mainline linux kernel
>> git tree, and find the tag from the kernel git tree that this source
>> code is most similar to.
>
> The kernel *knows* which version it is.
>
>> My plan at the moment is just to automate a checkout of every git tag,
>> then run diff -ur on it, and then choose the smallest diff files
>> output.n
>> But, has anyone got a better method?
>
> head -5 Makefile
>
I forgot to mention that in this particular situation, use of the
Makefile does not help.
The linux tree is a tar file to tar over the top of an existing
mainline tree. e.g. Kernel 3.2
It includes the following directories:
drivers
firmware
include
sound

I was wanting to somehow take the include directory, and find out
which kernel version best matches the include in the tar file.
The do the same for the other directories.
I guess I am looking for a sort of git bisect, but instead of finding
a bug, finding a version that best matches some source files.

In the mean time, I have done the diff -ur method on various tags, and
found that kernel 3.2.5 is the best match.
I now have a much smaller patch file, that I can start to get working
with the latest git tree.

Kind Regards

James
