Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbaHUJdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 05:33:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34896 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbaHUJdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 05:33:00 -0400
Message-ID: <53F5BCC8.4060000@suse.cz>
Date: Thu, 21 Aug 2014 11:32:56 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: Make scripts executable
References: <1408543848-24977-1-git-send-email-mmarek@suse.cz> <20140821122521.2D67.AA925319@jp.panasonic.com>
In-Reply-To: <20140821122521.2D67.AA925319@jp.panasonic.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-21 05:25, Masahiro Yamada wrote:
> Hi Michal,
> 
> 
> On Wed, 20 Aug 2014 16:10:48 +0200
> Michal Marek <mmarek@suse.cz> wrote:
> 
>> The Makefiles call the respective interpreter explicitly, but this makes
>> it easier to use the scripts manually.
>>
>> Signed-off-by: Michal Marek <mmarek@suse.cz>
> 
> 
> I am not sure at all, but
> it seems scripts/checkpatch.pl has a rule
> to ban execute permissions.

I didn't know about this, but the intent of the rule seems to be to
avoid *.c files with execute permissions.


> # Check for incorrect file permissions
>                 if ($line =~ /^new (file )?mode.*[7531]\d{0,2}$/) {
>                         my $permhere = $here . "FILE: $realfile\n";
>                         if ($realfile !~ m@scripts/@ &&
>                             $realfile !~ /\.(py|pl|awk|sh)$/) {

Here it explicitly skips files below scripts/ and files with known
script suffixes.

Michal
