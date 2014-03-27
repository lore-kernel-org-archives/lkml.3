Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaC0CIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 22:08:25 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:36886 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaC0CIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 22:08:24 -0400
MIME-Version: 1.0
From: Alejandro Comisario <alejandro.comisario@mercadolibre.com>
Date: Wed, 26 Mar 2014 23:08:03 -0300
Message-ID: <CAMrG31z=oy-53Lfya4svhNniD_7Q1YETuHeZsotHj8U5xJNYmw@mail.gmail.com>
Subject: Massive read only kvm guests when backing file was missing
To: Stefan Hajnoczi <stefanha@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi List!
Hope some one can help me, we had a big issue in our cloud the other
day, a couple of our openstack regions ( +2000 kvm guests with qcow2 )
went read only filesystem from the guest side because the backing
files directory (the openstack _base directory) was compromised and
the data was lost, when we realized the data was lost, it took us 5
mins to restore the backup of the backing files, but by that time all
the kvm guests received some kind of IO error from the hypervisor
layer, and went read only on root filesystem.

My question would be, is there a way to hold the IO operations against
the backing files ( i thought that would be 99% READ operations ) for
a little longer ( im asking this because i dont quite understand what
is the process and when it raises the error ) in a case the backing
files are missing (no IO possible) but is recoverable within minutes ?

Any tip  on how to achieve this if possible, or information about how
backing files works on kvm, will be amazing.
Waiting for feedback!

kindest regards.
Alejandro Comisario
