Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464Ab3CGRXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 12:23:44 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:45260 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab3CGRXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 12:23:43 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Rakib Mullick <rakib.mullick@gmail.com>, linux-kernel@vger.kernel.org
References: <20130307132819.GA31162@localhost>
Date: Thu, 07 Mar 2013 09:23:35 -0800
In-Reply-To: <20130307132819.GA31162@localhost> (Fengguang Wu's message of
	"Thu, 7 Mar 2013 21:28:19 +0800")
Message-ID: <87sj47t97s.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18Tb848og4+tXY+8BmPAiA+xVIIyT4jDFQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_12 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Fengguang Wu <fengguang.wu@intel.com>
X-Spam-Relay-Country: 
Subject: Re: [nsproxy] BUG: unable to handle kernel NULL pointer dereference at 0000000000000024
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu <fengguang.wu@intel.com> writes:

> Greetings,
>
> I got the below oops and the first bad commit is

Doh!  On a second look that change is totally wrong.  Of course we need
to up the ref-count every time we create a new process.  Especially if
we don't do anything with namespaces.

I was looking at it from the wrong angle last night.  I should have
known better.

Patch dropped.

Thanks,
Eric
