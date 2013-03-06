Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564Ab3CFPpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 10:45:19 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55945 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab3CFPpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 10:45:16 -0500
Message-ID: <51376453.3030308@linux.vnet.ibm.com>
Date: Wed, 06 Mar 2013 07:44:19 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: bp@alien8.de, hpa@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [3.9-rc1 x86] Bug in ioremap code?
References: <201303060041.AIF15342.tJFOHLQFFOMVSO@I-love.SAKURA.ne.jp> <20130305180650.GD4914@pd.tnic> <201303060628.CBG00578.OJtMFFHLQVSFOO@I-love.SAKURA.ne.jp> <51367104.5050200@linux.vnet.ibm.com> <20130305224432.GD27022@pd.tnic> <201303062358.EFG90616.HLtSQFJFOMVOFO@I-love.SAKURA.ne.jp>
In-Reply-To: <201303062358.EFG90616.HLtSQFJFOMVOFO@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030615-7182-0000-0000-000005AA7006
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 06:58 AM, Tetsuo Handa wrote:
> I don't know why but changing kernel config to CONFIG_ACPI=n
> ( http://I-love.SAKURA.ne.jp/tmp/config-3.9-rc1-noacpi ) solves this bug.
> Well, should I run bisection on ACPI code?

The ACPI code definitely _triggers_ it.  However, if you bisect, I bet
you'll just bisect down to the new debugging check that you're hitting:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=a25b9316841c5afa226f8f70a457861b35276a92

So, if you're able to bisect it, you'll need to apply that patch
whenever you're at a bisect point _before_ it was applied.  That might
also mean doing some merging because I'm sure the code around there has
changed.  IOW, bisecting isn't going to be super-easy.

