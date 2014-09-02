Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbaIBVAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:00:48 -0400
Received: from bowie.eng.utah.edu ([155.98.110.113]:47810 "EHLO
	bowie.eng.utah.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225AbaIBVAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:00:46 -0400
X-Greylist: delayed 1499 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Sep 2014 17:00:46 EDT
Message-ID: <54062A22.6090804@eng.utah.edu>
Date: Tue, 02 Sep 2014 14:35:46 -0600
From: Scotty Bauer <sbauer@eng.utah.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Compat sysinfo syscall (kernel/sys.c) relying on undefined behavior?
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 am getting acquainted with the linux kernel and to do so I've been browsing the source.


In the compat version of sysinfo, kernel/sys.c we see the following:

COMPAT_SYSCALL_DEFINE1(sysinfo, struct compat_sysinfo __user *, info)
{
    struct sysinfo s;

    do_sysinfo(&s);

    /* Check to see if any memory value is too large for 32-bit and scale
     *  down if needed
     */
    if ((s.totalram >> 32) || (s.totalswap >> 32)) {
        int bitcount = 0;

...


s.totalram is a u32, and the standard says:
"If the value of the right operand is negative or is greater than or equal to the width 
of the promoted left operand, the behavior is undefined."

Is there some promotion, compiler flag, something obvious that I am missing, or is this a 
problem?


Best,
Scotty

