Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab3G1BhI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 21:37:08 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57672 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752913Ab3G1BhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 21:37:07 -0400
Message-ID: <1374975425.2075.16.camel@joe-AO722>
Subject: Re: [PATCH v2 1/5] Staging: bcm: LeakyBucket: Fixed spacing/tabing
 issues
From: Joe Perches <joe@perches.com>
To: Lilis Iskandar <veeableful@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        tulinizer@gmail.com, linux-kernel@vger.kernel.org
Date: Sat, 27 Jul 2013 18:37:05 -0700
In-Reply-To: <1374953687-14386-1-git-send-email-veeableful@gmail.com>
References: <1374953687-14386-1-git-send-email-veeableful@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-07-28 at 03:34 +0800, Lilis Iskandar wrote:
> I don't understand what you mean by mentioning "git diff -w".
> Perhaps you can clarify it for me? Sorry :(

$ git diff --help | grep -w -A2 "\-w"
      -w, --ignore-all-space
           Ignore whitespace when comparing lines. This ignores differences even if one line has whitespace where the other line has none.

It makes sure you are doing only whitespace changes.
Any other changes show up as an actual diff.

You can also compile the changes and make sure
the .o files before and after don't change.

(Something like: assuming a clean tree)

$ cat compare_patch_obj_diffs.sh
#!/bin/bash

if [[ ! -e $1 || ! -f $1 ]]
then
    echo "$1 not found"
    exit $?
fi

grep -P "^\+\+\+" $1 |
while read file
do
    real_file=$(echo $file | cut -f2- -d'/')
    if [[ ${real_file:(-2)} == ".c" ]]
    then
	obj=${real_file%.c}.o
	make $obj
	mv $obj $obj.old
	patch -p1 < $1
	make $obj
	mv $obj $obj.new
	patch -p1 -R < $1
	size $obj.old $obj.new
	if [[ $2 == "y" ]]
	then
	    objdump -d $obj.old > $obj.old.dmp
	    objdump -d $obj.new > $obj.new.dmp
	    diff $obj.old.dmp $obj.new.dmp
	    rm -f $obj.old.dmp $obj.new.dmp
	fi
    fi
done


