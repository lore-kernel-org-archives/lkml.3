Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760477Ab3D3MCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 08:02:21 -0400
Received: from zep00a03.dent.med.uni-muenchen.de ([138.246.161.8]:47044 "HELO
	md.dent.med.uni-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759488Ab3D3MCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 08:02:20 -0400
From: Wolfram Gloger <wmglo@dent.med.uni-muenchen.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [ 03/42] TTY: fix atime/mtime regression
In-Reply-To: <20130429184752.796052982@linuxfoundation.org>
References: <20130429184752.796052982@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        wmglo@dent.med.uni-muenchen.de
Date: Tue, 30 Apr 2013 14:02:16 +0200
Message-ID: <u4k3nk6xbr.fsf@md.dent.med.uni-muenchen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>To revert to the old behaviour while still preventing attackers to
>guess the password length, we update the timestamps in one-minute
>intervals by this patch.

Sorry if I miss something, but isn't this an issue that should be very
obviously fixed in user space?  Only user space knows whether the
atime/mtime updates on a device are security-sensitive or not.

The sshd process and/or the login process could easily perform randomly
timed, dummy utime() calls on the tty around and within the password
typing, making this attack unfeasible.  I faintly remember sshd _already
does this_ for the network packets anyway by exchanging dummy packets.

Regards,
Wolfram.
