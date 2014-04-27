Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbaD0HIg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:08:36 -0400
Received: from si-002-i45.relay.mailchannels.net ([184.154.112.210]:40101 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752879AbaD0HIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:08:35 -0400
X-Sender-Id: totalchoicehosting|x-authuser|oren%2bscalemp.com
X-Sender-Id: totalchoicehosting|x-authuser|oren%2bscalemp.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: totalchoicehosting%7Cx-authuser%7Coren%252bscalemp.com
X-MailChannels-Auth-Id: totalchoicehosting
Message-ID: <535CAA77.4000405@scalemp.com>
Date: Sun, 27 Apr 2014 09:57:59 +0300
From: Oren Twaig <oren@scalemp.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH v2] X86: Hook apic vector allocation domain only when
 interrupt routing are set to ignore
References: <1398376326-3055-1-git-send-email-oren@scalemp.com> <20140425142248.GL8874@tassilo.jf.intel.com>
In-Reply-To: <20140425142248.GL8874@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AuthUser: oren+scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On 04/25/2014 05:22 PM, Andi Kleen wrote:
>> +static int irc = 1;
> Using a static for such state is very unusual. You need to describe what
> protects it against races and why that is needed over a cleaner solution.

The only reason I've used a static variable is because I wanted to avoid
inserting another code/functions which are depended on CONFIG_PCI.  The code is
used once during initialization and hence cannot be racy.

 
But, if static variables are unusual (new at linux kernel), I will change the
flow to read the HW state again (using the PCI functions).  Please let me know if that is desirable.

Thanks,
   Oren.
 
>
> -Andi


