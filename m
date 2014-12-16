Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbaLPM4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 07:56:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47287 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaLPM4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 07:56:19 -0500
Date: Tue, 16 Dec 2014 12:56:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeremiah Mahler <jmmahler@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [BUG, linux-next] spawn PID 1 without CLONE_FS, wireless inop
Message-ID: <20141216125615.GZ22149@ZenIV.linux.org.uk>
References: <20141216115537.GA1259@hudson.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216115537.GA1259@hudson.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 03:55:37AM -0800, Jeremiah Mahler wrote:
> all,
> 
> The wireless network interface has become inoperative when running
> linux-next 20141216 on a Lenovo Carbon X1.  It is completely
> non-existent and `ip addr` doesn't show it.  A bisect has found that
> the bug was introduced by the following commit.

Very interesting.  What userland are you running?  I take it, the root
filesystem is mounted and system boot except for that interface not
coming up, right?

Your card is normally handled by what, iwlwifi?  What happens upon
modprobe iwlwifi (or whatever module you see loaded on the normal
boot)?  Another interesting question is whether it manages to load
the firmware...  What happens if you boot with debug in kernel command
line, with working and with non-working kernels resp.?
