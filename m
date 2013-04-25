Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab3DYPTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 11:19:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56997 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811Ab3DYPTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 11:19:52 -0400
Message-ID: <51794990.6050405@zytor.com>
Date: Thu, 25 Apr 2013 08:19:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] random: Account for entropy loss due to overwrites
References: <1366777569-23192-1-git-send-email-hpa@zytor.com> <1366777569-23192-3-git-send-email-hpa@zytor.com> <CA+55aFwkEMAkvZFdeQm2PKQD1xgFBfVa+kTwJXGmWXoDqDp7xQ@mail.gmail.com> <51794141.3070205@zytor.com> <517942AB.1010201@zytor.com>
In-Reply-To: <517942AB.1010201@zytor.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On this subject, I assume this is a bug?

   871
   872                  if (r->entropy_count / 8 >= nbytes + reserved)
   873                          r->entropy_count -= nbytes*8;
   874                  else
   875                          r->entropy_count = reserved;
   876

[specifically the use of "reserved" as opposed to "reserved*8" on line 875?]

	-hpa

