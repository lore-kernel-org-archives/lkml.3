Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbbAMXmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 18:42:45 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:50850 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbbAMXmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 18:42:44 -0500
Message-ID: <54B5AD71.80404@android.com>
Date: Tue, 13 Jan 2015 15:42:41 -0800
From: Mark Salyzyn <salyzyn@android.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: LKML <linux-kernel@vger.kernel.org>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 3/5] pstore: handle zero-sized prz in series
References: <1421188372-1783-1-git-send-email-salyzyn@android.com> <CAGXu5jKeTzBepFogZvi0JbXnU8MuEi2tcQ45pQLdFMymmugvgw@mail.gmail.com>
In-Reply-To: <CAGXu5jKeTzBepFogZvi0JbXnU8MuEi2tcQ45pQLdFMymmugvgw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 03:08 PM, Kees Cook wrote:
> On Tue, Jan 13, 2015 at 2:32 PM, Mark Salyzyn <salyzyn@android.com> wrote:
>> ramoops_pstore_read fails to return the next in a prz
>> series after first zero-sized entry, not venturing to
>> the next non-zero entry.
>>
>> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
> This seems fine. Out of curiosity, when was the bad behavior this encountered?
During integration testing of the pmsg interface, we found that if any 
(most notably ftrace) of the previous prz's were zero in length. Before 
the addition of pmsg it would have occurred if you zero'd the console 
size, but had ftrace set; an unlikely scenario _until_ pmsg was added.
>
> Acked-by: Kees Cook <keescook@chromium.org>
>
> Thanks!
>
> -Kees
>
Thanks
