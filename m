Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab3LJWFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:05:41 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:40349 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751615Ab3LJWFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:05:40 -0500
Message-ID: <52A79030.9090403@hurleysoftware.com>
Date: Tue, 10 Dec 2013 17:05:36 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Stas Sergeev <stsp@list.ru>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Margarita Manterola <margamanterola@gmail.com>,
        Maximiliano Curia <maxy@gnuservers.com.ar>,
        Stas Sergeev <stsp@users.sourceforge.net>, Pavel Machek <pavel@ucw.cz>,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, Caylan Van Larson <i@caylan.net>
Subject: Re: [PATCH v3] n_tty: Fix buffer overruns with larger-than-4k pastes
References: <529F7B35.4050509@list.ru> <1386600604-5092-1-git-send-email-peter@hurleysoftware.com> <52A5EF3F.2070805@list.ru> <52A5F96A.6030900@hurleysoftware.com> <52A6B179.5050104@list.ru>
In-Reply-To: <52A6B179.5050104@list.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 01:15 AM, Stas Sergeev wrote:
> 09.12.2013 21:10, Peter Hurley пишет:
>> On 12/09/2013 11:26 AM, Stas Sergeev wrote:
>>> 09.12.2013 18:50, Peter Hurley пишет:
>>>>       if (found && read_buf(ldata, eol) == __DISABLED_CHAR) {
>>>>           n--;
>>>>           eof_push = !n && ldata->read_tail != ldata->line_start;
>>>> +        ldata->push = 0;
>>>>       }
>>> Will this work if the last (and only) char written in raw
>>> mode appear to be \0 (__DISABLED_CHAR)?
>>
>> That would have triggered an EOF in older kernels so not a
>> regression.
> I mean the case when icanon is enabled _after_ the
> \0 was written. In an unpatched kernel it will not result
> in an EOL mark, so I don't expect it to trigger EOF.

Right you are, Stas.
I found some other problems as well, so v4 coming.

Regards,
Peter Hurley
