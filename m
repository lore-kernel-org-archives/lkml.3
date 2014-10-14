Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233AbaJNLxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 07:53:00 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:58682 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaJNLw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 07:52:59 -0400
X-ASG-Debug-ID: 1413287576-0759e748287b92a0002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Tue, 14 Oct 2014 13:52:34 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: 8250_core: use pre-decrement for iteration limit
Message-ID: <20141014115234.GB15616@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [PATCH] serial: 8250_core: use pre-decrement for iteration limit
References: <1413212951-20901-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1413212951-20901-1-git-send-email-frans.klaver@xsens.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.125]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1413287576
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.10555
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 05:09:11PM +0200, Frans Klaver wrote:
> In serial8250_rx_chars(), max_count is set to 256. Due to the
> post-decrement operator used in the while() condition, the maximum
> number of iterations actually 257. This is not a problem, but it is
> mildly surprising if you're debugging. Use pre-decrement instead.

I'm somewhat inclined to changing the title to something like:

serial: 8250_core: actually limit char reads to max_count

Frans
