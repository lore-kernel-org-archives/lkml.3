Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaBOKfb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:35:31 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52928 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaBOKfb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:35:31 -0500
From: Catalin Marinas <Catalin.Marinas@arm.com>
To: Olof Johansson <olof@lixom.net>
CC: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date: Sat, 15 Feb 2014 10:28:15 +0000
Subject: Re: [PATCH] ARM64: unwind: Fix PC calculation
Thread-Topic: [PATCH] ARM64: unwind: Fix PC calculation
Thread-Index: Ac8qOJevKh3Ul2hgTcKBa0U2pEswAw==
Message-ID: <BBC3AB9B-17A9-4112-B8CC-D3DCB3B673D9@arm.com>
References: <1392406515-27835-1-git-send-email-olof@lixom.net>
In-Reply-To: <1392406515-27835-1-git-send-email-olof@lixom.net>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
MIME-Version: 1.0
X-MC-Unique: 114021510275702902
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Feb 2014, at 19:35, Olof Johansson <olof@lixom.net> wrote:
> The frame PC value in the unwind code used to just take the saved LR
> value and use that.  That's incorrect as a stack trace, since it shows
> the return path stack, not the call path stack.
>
> In particular, it shows faulty information in case the bl is done as
> the very last instruction of one label, since the return point will be
> in the next label. That can easily be seen with tail calls to panic(),
> which is marked __noreturn and thus doesn't have anything useful after it.
>
> Easiest here is to just correct the unwind code and do a -4, to get the
> actual call site for the backtrace instead of the return site.
>
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Cc: stable@vger.kernel.org

Looks fine. I’ll push it sometime next week. Thanks.

Catalin

-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.

ARM Limited, Registered office 110 Fulbourn Road, Cambridge CB1 9NJ, Registered in England & Wales, Company No:  2557590
ARM Holdings plc, Registered office 110 Fulbourn Road, Cambridge CB1 9NJ, Registered in England & Wales, Company No:  2548782

