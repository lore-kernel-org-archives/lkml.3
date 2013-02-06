Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab3BFGbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 01:31:35 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:53670 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3BFGbd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 01:31:33 -0500
MIME-Version: 1.0
Date: Wed, 6 Feb 2013 15:31:32 +0900
Message-ID: <CAKYAXd9rmsSFTQ98oAOoddjJagv0tpcPKLXZs231SRmyfdyqBA@mail.gmail.com>
Subject: [LSF/MM TOPIC] f2fs: Dynamic Control of GC Thread at User Level and
 Stabilizing sudden eject behavior for SD Cards.
From: Namjae Jeon <linkinjeon@gmail.com>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nam-Jae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I am considering the following subjects on f2fs. I'm not sure if it is
proper TOPIC.
Let me know opinions :)

1. Dynamic Control of GC Thread at User Level.
To cope with rapid increase in number of smart phone users and
increasing demands for different media application with Quality Of
Service (QoS) interaction on such devices,
it is becoming imperative to provide the necessary support at the
underlying filesystem layer also.
Currently, when we consider the Garbage collection behavior and its
execution period overlapping with the normal I/O - while garbage
collection is in progress it results in blocking the normal I/O Path,
i.e.,
it provides a sense of unresponsiveness to the user and could also
potentially feel like a hung state in the worst cases, resulting in
hard-reboot from the user.
So, in order to improve upon this behavior. We can introduce the
“dynamic control” concept for the Garbage collection.
It will allow the user to check the status of garbage at any time and
in-turn will also allow user to run the GC from the user interface.
It can be similar to the concept of checking the fragmentation level
of filesystem and running defragmentation and showing status
dynamically.
For a specific scenario we can have an example like this: When
Application is recording Video data on some storage device or showing
screen by decoding (TV) or may be the device is switching to idle
mode.
In such cases Application will have the intelligence that there is no
access to F2Fs partition at such intervals, and which partitions are
not used on such times. In such intervals if the Application user can
control the GC thread,
it will allows the F2FS partition be ready in advance and normal I/O
can run properly without any intervention from the GC thread.

2. Stabilizing sudden eject behavior for SD Cards
As a continuation to the usage of smart phone and related devices, the
trend is that the usage of SD cards on mobile devices in on increase.
It is a great challenge to have the content on SD cards intact as well
keep the system stable while using SD cards.
Currently, when F2FS formatted SD card is connected to the device and
I/O is in progress- there are several code paths in the F2FS
filesystem which tried to guarantee no failure for few routines.
But this results in abnormal situation, because initially F2FS design
did not take into account the sudden unplug behavior. As a result it
potentially left various paths which resulted in infinite looping even
in the case when the device is removed,
which in-turn actually results in hung state for the device as it is
not able to come out of the tight loop to handle other interrupts.
To combat such problem there is a need for redesign which allows both
guarantee for no failure in default routines and safe exit
routines/fallback path in case of unsafe device ejection.

Thanks.
