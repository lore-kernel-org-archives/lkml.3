Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab3EHPSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:18:13 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:33916 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752986Ab3EHPSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:18:11 -0400
Message-ID: <518A6CAF.9020301@hurleysoftware.com>
Date: Wed, 08 May 2013 11:18:07 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Wang YanQing <udknight@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>, jslaby@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]TTY: Fix tty can't be restarted by TCXONC ioctl request
References: <20130507184734.GA2459@udknight> <20130507185800.GA10713@kroah.com> <20130508015545.GA1937@udknight> <20130508020200.GA15695@kroah.com> <20130508131624.GA1938@udknight>
In-Reply-To: <20130508131624.GA1938@udknight>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 09:16 AM, Wang YanQing wrote:
> On Tue, May 07, 2013 at 07:02:00PM -0700, Greg KH wrote:
>> What about Peter's comments on this patch?
>>
> Peter's comments will import policy,
>
> I means we should let userspace to decide whether
> and when to restart tty with the mechanism of TCXONC
> instead of restart tty accidental when make n_tty_set_termios
> call.

There would be no accidental restart. Userspace is specifically
disabling user-controlled output flow control by clearing
IXON in termios. Userspace is _expecting_ a 'started' tty.

If you insist that this must be controllable from userspace,
then that is already possible:

	tcflow(fd, TCOOFF);
	tcflow(fd, TCOON);


Regards,
Peter Hurley

