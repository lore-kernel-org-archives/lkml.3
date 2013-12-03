Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab3LCTTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 14:19:30 -0500
Received: from fallback3.mail.ru ([94.100.176.58]:47221 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab3LCTT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 14:19:28 -0500
Message-ID: <529E2E92.4010004@list.ru>
Date: Tue, 03 Dec 2013 23:18:42 +0400
From: Stas Sergeev <stsp@list.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Margarita Manterola <margamanterola@gmail.com>,
        Maximiliano Curia <maxy@gnuservers.com.ar>,
        Stas Sergeev <stsp@users.sourceforge.net>, Pavel Machek <pavel@ucw.cz>,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Caylan Van Larson <i@caylan.net>
Subject: Re: Large pastes into readline enabled programs causes breakage from
 v2.6.31 onwards
References: <5291E92F.7010609@hurleysoftware.com> <1385428582-5577-1-git-send-email-peter@hurleysoftware.com> <529D236E.4020002@hurleysoftware.com> <529D9DCD.5080003@list.ru> <529E0E1F.4010303@hurleysoftware.com>
In-Reply-To: <529E0E1F.4010303@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

03.12.2013 21:00, Peter Hurley пишет:
> Any unit test is specifically designed to break the code under test.
> This unit test does in fact break a possible input: note specifically
> that the writer is not changing the termios so has no control over
> the timing of when the input is received.
>
> Also note that the test is a simulation; the patch will break any
> input stream under the following conditions:
> 1. The writer writes an EOF-terminated buffer
> 2. All the input is received _except_ the EOF; this is strictly
>    timing-related and not controllable.
> 3. The reader changes the termios from non-canon -> canon.
>
> At that point the damage is done; the read_flags will indicate
> 2 EOFs and the 2nd EOF will be interpreted as end-of-file because
> it will appear to begin on a new line.
How is this different from the unpatched kernel?
In the unpatched kernel, if you happen on reader side
to enable icanon while n_tty received all but VEOF (is this possible at 
all?),
then the buffer will be flushed, and the remaining VEOF
will get you a nice EOF.
So, in the unpatched kernel you get EOF because the buffer
gets wiped.
On patched kernel you get EOF because of 2 consequitive marks
in read_flags.
This is intentional, for backward compatibility.
What is the problem with that, why do you call it a breakage?
Or am I misreading the scenario you describe?
