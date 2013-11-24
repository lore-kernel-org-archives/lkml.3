Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab3KXLzj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 06:55:39 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:59713 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752005Ab3KXLzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 06:55:35 -0500
Message-ID: <5291E92F.7010609@hurleysoftware.com>
Date: Sun, 24 Nov 2013 06:55:27 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Pavel Machek <pavel@ucw.cz>, Maximiliano Curia <maxy@gnuservers.com.ar>,
        Margarita Manterola <margamanterola@gmail.com>,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, bug-readline@gnu.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: Large pastes into readline enabled programs causes breakage from
 v2.6.31 onwards
References: <CAP+fKSpvJqeh8JCHisByDBsGWPOWOcDN4qeVYJOn1tgg8HR0eg@mail.gmail.com>	<CAP+fKSp5ze3-qWHY_D_e3AXxnFM-AB9FBfRLjy0yOFnOp6bp4w@mail.gmail.com>	<201309030717.57866.a.miskiewicz@gmail.com>	<201310241800.18490.a.miskiewicz@gmail.com>	<20131029135036.GA30992@gnuservers.com.ar>	<5270EBA9.6070302@hurleysoftware.com>	<20131117182906.GE30012@xo-6d-61-c0.localdomain>	<528D946B.8030000@hurleysoftware.com>	<528F54A2.5000802@hurleysoftware.com> <20131124002945.19bde9ab@alan.etchedpixels.co.uk>
In-Reply-To: <20131124002945.19bde9ab@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2013 07:29 PM, One Thousand Gnomes wrote:
>> 7) Rescan line discipline buffer when changing from non-canonical to canonical
>> mode. The real problem with this approach (besides the inefficiency) is that this
>> solution could break some (admittedly unknown) program that contrived to exchange
>> data in non-canonical mode but read in canonical mode (just not exceeding the
>> line discipline buffer limit).
>
> See bugzilla 55981, 55991 btw

Thanks for the bug references, Alan.

The solution proposed in 55991 (to perform an EOF push when switching from
non-canon to canon) would further break paste to readline().

The caller to readline() may not actually perform any read() but may
simply loop, calling readline();  in this case, when readline()
switches back to non-canonical, it will eventually read the inserted '\0'.
That would be bad.

Regards,
Peter Hurley


