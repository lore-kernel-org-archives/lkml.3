Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbaEZHSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 03:18:07 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:52434 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaEZHSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 03:18:06 -0400
X-AuditID: 85900ec0-d452db9000001514-e5-5382eaaa5e92
Message-ID: <5382EAA9.1010003@hitachi.com>
Date: Mon, 26 May 2014 16:18:01 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Randy Dunlap <rdunlap@infradead.org>, Petr Mladek <pmladek@suse.cz>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>
Subject: Re: Re: [RFC PATCH 1/2] printk: Add context information to the
 header of /dev/kmsg
References: <20140519102835.30455.10437.stgit@yunodevel>            <20140519102838.30455.86863.stgit@yunodevel> <11176.1400556970@turing-police.cc.vt.edu>
In-Reply-To: <11176.1400556970@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(2014/05/20 12:36), Valdis.Kletnieks@vt.edu wrote:
> On Mon, 19 May 2014 19:28:38 +0900, Yoshihiro YUNOMAE said:
>
>> The header information is changed as follows:
>>     <prefix>,<seq#>,<timestamp>,<fragmented>,<PID>/<interrupt context>;<msg>
>
> Has this been tested with popular userspace that reads /dev/kmsg, to make
> sure that it actually plays nice with a 5th field being added?  Yes, I know

I checked it for systemd-journald and rsyslog on the source code level,
those tools don't handle new flag and field before ';' in the header of
/dev/kmsg. Those tools use only log level, sequence#, and timestamp.
So, even if we add these new flag and field for each message,
those tools will be able to work.

But, we'll fix this issue by other method if we found it in any
subsystems except for the SCSI layer.
(In the SCSI layer, we'll tackle this issue by using tracing feature.)

Thank you,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


