Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab3JKFTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 01:19:17 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:45442 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab3JKFTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 01:19:16 -0400
Message-ID: <52578A4D.2000300@gmail.com>
Date: Fri, 11 Oct 2013 16:19:09 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>, ebiederm@xmission.com, joe@perches.com
CC: akpm@linux-foundation.org, dan.j.rosenberg@gmail.com,
        eldad@fogrefinery.com, jgunthorpe@obsidianresearch.com,
        jkosina@suse.cz, keescook@chromium.org,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH v3a] vsprintf: Check real user/group id for %pK
References: <20131011044232.11545.qmail@science.horizon.com>
In-Reply-To: <20131011044232.11545.qmail@science.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/13 15:42, George Spelvin wrote:
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>> Sigh.  This is all wrong.  The only correct thing to test is
>> file->f_cred.  Aka the capabilities of the program that opened the
>> file.
>>
>> Which means that the interface to %pK in the case of kptr_restrict is
>> broken as it has no way to be passed the information it needs to make
>> a sensible decision.
> 
> I looked at the code, and pretty painful.  Certainly it's possible to
> include a reference to the file (I was thinking of just the credentials,
> actually) in the seq_file.  But getting that to the vsprintf.c code
> (specifically, the pointer() function) is a PITA.
> 
> I'm willing to accept the currently proposed kludge as a "good enough"
> approximation, as long as we're all agreed that using the credentials
> at open() time would be The Right Thing, and hopefully someone will find
> the round tuitts to implement that in future.
> 
> But in the meantime, "the perfect is the enemey of the good" is worth
> remembering.
> 
> (An alternate implementation I've been thinking about would be to do
> away with %pK, and instead have a "secret_ptr(p, seq->cred)" helper that
> returned p or 0 depending on the credential.)

Yeah, that is probably the best solution. I'll try to put together a
patch series doing this. It will obviously be more involved though, so I
think it is still worth merging the original patch in the interm.

~Ryan



