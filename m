Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab3B1Loi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 06:44:38 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:47244 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3B1Loh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 06:44:37 -0500
X-IronPort-AV: E=Sophos;i="4.84,755,1355097600"; 
   d="scan'208";a="2019290"
Message-ID: <512F4323.50607@citrix.com>
Date: Thu, 28 Feb 2013 12:44:35 +0100
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130216 Thunderbird/17.0.3
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC 00/12] xen-block: indirect descriptors
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com> <512F443702000078000C1DF7@nat28.tlf.novell.com> <512F3EA9.1070704@citrix.com> <512F4F0102000078000C1EB8@nat28.tlf.novell.com>
In-Reply-To: <512F4F0102000078000C1EB8@nat28.tlf.novell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/02/13 12:35, Jan Beulich wrote:
>>>> On 28.02.13 at 12:25, Roger Pau Monné<roger.pau@citrix.com> wrote:
>> This is the expanded graph that also contains indirect descriptors
>> without persistent grants:
>>
>> http://xenbits.xen.org/people/royger/plot_indirect_nopers.png 
> 
> Thanks. Interesting - this suggests an unexpectedly high hit rate.

This graph is using the default values, so we are persistently mapping
1024 grants of the possible 2080 that could be used by blkfront ((64
segments + 1 indirect gref) * 32 = 2080).

blkfront stores grants using a stack, so it should try to reuse the same
grants as much as possible. On the other hand, blkback cleans unused
grants periodically, to try to have the most commonly used blkfront
grants mapped.

