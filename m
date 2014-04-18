Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaDROpd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 10:45:33 -0400
Received: from www.meduna.org ([92.240.244.38]:60802 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaDROp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 10:45:29 -0400
Message-ID: <53513A7E.5050907@meduna.org>
Date: Fri, 18 Apr 2014 16:45:18 +0200
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: jordan <triplesquarednine@gmail.com>
CC: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: spinlock trylock failure on UP - reverting timer patches
 helps
References: <534C3606.7010206@meduna.org>	<534C731F.1050406@meduna.org>	<534DADF1.6060608@meduna.org>	<53500184.4050309@meduna.org>	<53505BD7.9050004@meduna.org> <CAOcfFMyTmQH-FwGE2YWoA76ypzBtWPYVTyi+4QpEMnrRtw8QVg@mail.gmail.com>
In-Reply-To: <CAOcfFMyTmQH-FwGE2YWoA76ypzBtWPYVTyi+4QpEMnrRtw8QVg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2014-04-18 16:45:23
X-Connected-IP: 95.105.163.217:53813
X-Message-Linecount: 47
X-Body-Linecount: 27
X-Message-Size: 2028
X-Body-Size: 939
X-Received-Count: 1
X-Recipient-Count: 7
X-Local-Recipient-Count: 7
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.04.2014 01:10, jordan wrote:

Hi Jordan,

many thanks for the tests. I probably botched something during
the reverting - I now tried some more experiments and the system
now runs without BUGs and without kernel leak - of course
it needs some more uptime to be really sure.

My combined revert patch from 3.12.15-rt25 is at
  http://pastebin.com/MYLqbmZw
That was all that was needed.

> Yeah, i know a handful of people [amd users] that have now reported
> success booting into 3.14-rt1 reverting those patches.  Personally, I
> have disabled NO_HZ_FULL and have switched back to 'old tick' method
> in kconfig. I don't think the latest no_hz stuff is stable enough...

My problems were with periodic timers (I am on an embedded system
that runs things periodically anyway and I have also my doubts
regarding the stability), so the latest code did not break
only NO_HZ_FULL.

Thanks
-- 
                                       Stano

