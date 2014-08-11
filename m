Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbaHKUgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 16:36:48 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:64405 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbaHKUgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 16:36:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140811105837.GO4856@mwanda>
References: <1407628152-24876-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140811105837.GO4856@mwanda>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Mon, 11 Aug 2014 22:36:26 +0200
Message-ID: <CAFo99gZr9MtM3YWj74KgpkBzKcVoMCEZtxU9mTUq2f3iY2NmKw@mail.gmail.com>
Subject: Re: [PATCH] staging: lustre: lustre: ptlrpc: nrs.c: Cleaning up
 missing null-terminate after strncpy call
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oleg Drokin <oleg.drokin@intel.com>, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>,
        Liang Zhen <liang.zhen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ann Koehler <amk@cray.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-11 12:58 GMT+02:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Sun, Aug 10, 2014 at 01:49:12AM +0200, Rickard Strandqvist wrote:
>> Added a guaranteed null-terminate after call to strncpy.
>
> No.  This is a problem in the static checker and not in the code.
>
> Look at the start of the function.  This stuff should be obvious for the
> static checker.
>
> regards,
> dan carpenter
>

Hi Dan

Okay, no, it was me who missed it, not cppcheck.

Ensuring that from string will fit was an unusual solution.
If I see code where an effort is made to ensure that no more than x
characters copied I react to it.
But it is zeroing of the string you were looking for then. Ok sorry :-(

Kind regards
Rickard Strandqvist
