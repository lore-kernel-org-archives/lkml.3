Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbaJXQZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 12:25:11 -0400
Received: from smtp-3.concepts.nl ([213.197.30.127]:38186 "EHLO
	smtp-3.concepts.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaJXQZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 12:25:08 -0400
Message-ID: <544A7D5C.5060804@xmsnet.nl>
Date: Fri, 24 Oct 2014 18:25:00 +0200
From: Hans de Bruin <jmdebruin@xmsnet.nl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.8.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-nfs@vger.kernel.org, ebiederm@xmission.com
Subject: Re: 3.17.0+ files disappearing after playing old dos game on nfsroot
 laptop
References: <543ED24D.4070905@xmsnet.nl> <5443F5A1.1050004@xmsnet.nl> <544A7933.3010702@xmsnet.nl>
In-Reply-To: <544A7933.3010702@xmsnet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Concepts-MailScanner-Information: Please contact abuse@concepts.nl for more information
X-Concepts-MailScanner-ID: 1Xhhfh-000Avk-Fq
X-Concepts-MailScanner: Found to be clean
X-Concepts-MailScanner-SpamCheck: 
X-Concepts-MailScanner-From: jmdebruin@xmsnet.nl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2014 07:32 PM, Hans de Bruin wrote:
> On 10/15/2014 10:00 PM, Hans de Bruin wrote:
>> After playing an old dos game i am missing files on my nfsroot installed
>> laptop. Which one, wel /bin/ls is at least one of them. After a reboot
>> there all back again.  But not al is well. Some icons on my kde panel
>> where gone. I have seen this twice in the last day's
>>
>
> The problem appears immediately after starting dosemu so this bisectable
>


My bisect ended here:

commit 8ed936b5671bfb33d89bc60bdcc7cf0470ba52fe
Author: Eric W. Biederman <ebiederman@twitter.com>
Date:   Tue Oct 1 18:33:48 2013 -0700


      vfs: Lazily remove mounts on unlinked files and directories.


I haven reverted it yet.



Eric,

Immediately after starting dosemu all files under mount point /usr are
gone. When I play a old dos game for a while (binaries are under /home)
even /bin/ls disappears. Al mounts are nfs, even /.

Could you look in to this and cc this to the relevant kernel mailinglist?

-- 
Hans
