Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbaJGNeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:34:12 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:43289 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbaJGNeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:34:10 -0400
X-ASG-Debug-ID: 1412688846-0759e74828c53e0002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Tue, 7 Oct 2014 15:34:05 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: Sebastian Reichel <sre@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] power: reset: add LTC2952 poweroff support
Message-ID: <20141007133404.GB25568@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [PATCH v3 1/2] power: reset: add LTC2952 poweroff support
References: <1412584836-27677-1-git-send-email-frans.klaver@xsens.com>
 <1412584836-27677-2-git-send-email-frans.klaver@xsens.com>
 <20141006213210.GA11926@roeck-us.net>
 <20141007081544.GA25568@ci00147.xsens-tech.local>
 <5433E7A3.4080707@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5433E7A3.4080707@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.125]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1412688846
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.10297
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 06:16:19AM -0700, Guenter Roeck wrote:
> On 10/07/2014 01:15 AM, Frans Klaver wrote:
> > On Mon, Oct 06, 2014 at 02:32:10PM -0700, Guenter Roeck wrote:
> 
> >> Any reason for not using devm_gpiod_get() for those functions ?
> >
> > René said in the first review round:
> >
> >>>>   devm_* functions do not seem to common to me and are sparsely
> >>>>   documented, therefore I preferred the regular functions. This
> >>>>   error jump should go to err_io and the clean-up loop must check
> >>>>   if the gpio entry is actually filled in
> >
> > I now unrolled these loops, and quite frankly I'm not that sure devm_*
> > functions are actually that sparsely used. The way to get around that is
> > to use them more. I'll see about using those instead, maybe add some
> > documentation as well.
> >
> 
> "git grep devm_| wc" on 3.17 returns 7344.
> 
> If that is not enough, nothing ever will.

Heh, precisely. I've switched to the devm_* functions. Code's much
cleaner now.

Thanks,
Frans
