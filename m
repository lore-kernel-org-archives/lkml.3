Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab3JPOnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:43:05 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:56470 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab3JPOnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:43:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAKDJKT7W-1S_KzZ5XEYJQuMnQEu17xbRjeNmZgj=-73Z0Kz_Qg@mail.gmail.com>
References: <1381923650-7556-1-git-send-email-manishv.b@ti.com>
	<525E9380.7090905@ti.com>
	<CAKDJKT7W-1S_KzZ5XEYJQuMnQEu17xbRjeNmZgj=-73Z0Kz_Qg@mail.gmail.com>
Date: Wed, 16 Oct 2013 09:43:01 -0500
X-Google-Sender-Auth: rDQ1YSyRvRLbyv984YHpph-wObA
Message-ID: <CAGo_u6rNJyzxtxn=0o-RC4487O+QuL5xE+vb+sP8_QxMg7g4yw@mail.gmail.com>
Subject: Re: [PATCH] PM/AVS: SmartReflex: fix fake probe success on debugfs fail
From: Nishanth Menon <nm@ti.com>
To: Manish Badarkhe <badarkhe.manish@gmail.com>
Cc: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>,
        linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, khilman@kernel.org,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 9:24 AM, Manish Badarkhe
<badarkhe.manish@gmail.com> wrote:
>
>>
>> IMHO, fail of creation of debugfs is not reason enough to fail the
>> probe - further, this code needs a major revamp to work with device tree.
>
> Yes, fail of debugfs creation should not be enough reason to fail probe. But as
> per current implementation of code, on debugfs failure smart reflex node is
> getting deleted and probe get failed. This patch not made any changes in
> logic of code but only makes proper use of  "IS_ERR_OR_NULL".

Thanks for the clarification, it was not obvious from the commit
message. Further, I would rather prefer to see a proper cleanup that
handles error completely, since IS_ERR_OR_NULL is not really
recommended anymore.
Regards,
Nishanth Menon
