Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab3EAFcC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 01:32:02 -0400
Received: from ozlabs.org ([203.10.76.45]:37143 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab3EAFbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 01:31:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tom Rini <trini@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] modpost.c: Add .text.unlikely to TEXT_SECTIONS
In-Reply-To: <517E7260.5070204@ti.com>
References: <1366842363-7513-1-git-send-email-trini@ti.com> <87sj2aca9r.fsf@rustcorp.com.au> <517E7260.5070204@ti.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 01 May 2013 11:49:47 +0930
Message-ID: <87ppxbxwzg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Rini <trini@ti.com> writes:
> On 04/28/2013 10:59 PM, Rusty Russell wrote:
>> Tom Rini <trini@ti.com> writes:
>> 
>>> Recent gcc's may place functions into the .text.unlikely section and we
>>> need to check this section as well for section mismatches now otherwise
>>> we may have false negatives for this test.
>> 
>> Hmm, I don't think it's all that recent, is it?  I can find it back to
>> gcc 4.0.4:
>> 
>> `-freorder-functions'
>>      Reorder functions in the object file in order to improve code
>>      locality.  This is implemented by using special subsections
>>      `.text.hot' for most frequently executed functions and
>>      `.text.unlikely' for unlikely executed functions.  Reordering is
>>      done by the linker so object file format must support named
>>      sections and linker must place them in a reasonable way.
>> 
>>      Also profile feedback must be available in to make this option
>>      effective.  See `-fprofile-arcs' for details.
>> 
>>      Enabled at levels `-O2', `-O3', `-Os'.
>> 
>> The comment is the same in in gcc 4.7.
>> 
>> So is your real issue that this section is generated with
>> -fprofile-arcs, or has something changed with gcc 4.8, or...?
>
> I've started seeing this with Linaro based 4.7 toolchains.  I can go
> back through their releases and see when it starts showing up there if
> it helps.  I didn't add .text.hot as I didn't have that section at all,
> fwiw.

Weird, did you turn on CONFIG_GCOV_KERNEL?  AFAICT you shouldn't see
this section without that.

Thanks,
Rusty.
