Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab3JXJj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:39:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49723 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109Ab3JXJjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:39:55 -0400
Message-ID: <5268EAE5.7040005@suse.cz>
Date: Thu, 24 Oct 2013 11:39:49 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: yann.morin.1998@free.fr, akpm@linux-foundation.org, joe@perches.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/checkkconfig.py: find unused Kconfig parameters
References: <1382592209-10246-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1382592209-10246-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.10.2013 07:23, Michael Opdenacker wrote:
> +       count = subprocess.check_output('git grep ' + param + '| grep -v defconfig | wc -l', shell=True)

Python 2.6 does not have subprocess.check_output:

$ ./scripts/checkkconfig.py
INFO: processing Kconfig files...
INFO: checking kconfig parameter 1 / 13706 (0 %)
Traceback (most recent call last):
  File "./scripts/checkkconfig.py", line 127, in <module>
    count_param(param)
  File "./scripts/checkkconfig.py", line 67, in count_param
    count = subprocess.check_output('git grep ' + param + '| grep -v
defconfig | wc -l', shell=True)
AttributeError: 'module' object has no attribute 'check_output'

Michal
